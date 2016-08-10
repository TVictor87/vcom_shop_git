class CatalogController < PagesController
  before_action :set_page
  before_action :set_show
  before_action :set_parent, only: :catalog
  before_action :set_category, only: :catalog
  before_action :set_product, only: :show

  def categories
    @category = Category.find_by(params[:column] => params[:url])
    rend 'catalog/categories'
  end

  def refresh_options
    options_params = params.select{|key, value| key.include?('id_') && value.present? }
                           .map{|key, value| [key[3..-1], value] }.to_h
    product_id = params['product_id']
    data = available_products_settings(product_id, options_params)
    @max = data[:max]
    @groups = data.select{|key, value| key.is_a? Numeric }

    respond_to do |format|
      format.js { render 'vkolgotkah/catalog/refresh_options' }
    end
  end

  def catalog
    get_products @category.id
    set_options

    @products = @products.select_few

    sort
    set_products

    rend 'catalog/catalog'
  end

  def catalog_json
    get_products params[:id].to_i

    @products = @products.select_few

    sort
    set_products

    render json: "{\"records\":#{@products.to_json(include: :images)},\"totalPage\":#{@total_page},\"min\":#{@from},\"max\":#{@to},\"available_options\":#{@available_options.to_json}}"
  end

  def show
    @product = Product.send("find_by_#{params[:column]}", params[:product_url])
    rend 'catalog/show'
  end

  private

  def get_products id
    @category_id = id
    condition = "products.category_id = #{id}"
    @where = [condition]
    @products = Product.where(condition)
    filter_by_options
  end

  def set_product
    @product = Product.send("find_by_#{params[:column]}", params[:product_url])
    @category = Category.find_by(params[:column] => params[:category_url], id: @product.category_id)
    @parent = @category.category
    @groups = get_init_options(@product.id)
    @max = 0
  end

  def available_products_settings(product_id, params = {})

    #empty selects

    if params.blank?
      groups = get_init_options(product_id)
      groups[:max] = 0
      return groups
    end

    #data - available products from warehouse
    data = []

    #groups - data for selects
    groups = {}

    params.each_with_index do |(group_id, settings), index|
      data = if !index.zero?
               WarehouseProduct.joins(:option_warehouse_products).joins(:options).where(id: data.pluck(:id), product_id: product_id, options: { option_group_id: group_id }, options_warehouse_products: { option_id: settings })
             else
               WarehouseProduct.joins(:option_warehouse_products).joins(:options).where(product_id: product_id, options: { option_group_id: group_id }, options_warehouse_products: { option_id: settings })
             end
    end

    groups[:max] = data.size

    data.inject([]){|arr, d| arr.concat(d.option_warehouse_products) }.map(&:option).uniq.each do |option|
      option_group = option.option_group
      form_option!(groups, option_group.id, option_group.title, option_group.field_type, option.id, option.value, params[option_group.id.to_s])
    end

    groups
  end

  def get_init_options(product_id)
    groups = {}

    ActiveRecord::Base.connection.select_rows(
        "SELECT og.id, og.title_#{locale}, og.field_type, o.id, o.value_#{locale}, wp.id "\
      "FROM warehouse_products wp "\
      "INNER JOIN options_warehouse_products owp ON owp.warehouse_product_id = wp.id "\
      "INNER JOIN options o ON o.id = owp.option_id "\
      "INNER JOIN option_groups og ON og.id = o.option_group_id "\
      "WHERE wp.product_id = #{product_id} ORDER BY og.priority"
    ).each{|row|
      form_option!(groups, row[0].to_i, row[1], row[2], row[3].to_i, row[4])
    }
    groups
  end

  def form_option!(collection, og_id, og_title, og_field_type, o_id, o_value, selected = nil)
    group_id = og_id
    if collection[group_id].nil?
      collection[group_id] = {title: og_title, selected: selected, field_type: og_field_type, options: {o_id => o_value}}
    else
      collection[group_id][:options].merge!(o_id => o_value) if collection[group_id][:options][o_id].nil?
    end
  end

  def filter_by_options
    @options_products = @products
    options = params[:options]
    if options
      @checked_options = []
      @grouped_options = {}
      for group_id, ids in options
        ids.map!(&:to_i)
        if ids.any?
          @checked_options += ids
          @grouped_options[group_id.to_i] = ids
        end
      end
      if @checked_options.any?
        @products = @products.where(product_id_by_groups @grouped_options)
      end
    else
      @checked_options = []
    end
    @checked_options_map = {}
    @checked_options.each{|id| @checked_options_map[id] = true}
    set_from_to
  end

  def product_id_by_groups grouped_options
    inner_join = []
    where = []
    i = 0
    for group_id, ids in grouped_options
      i += 1
      inner_join << "INNER JOIN options_products AS options_products#{i} ON options_products#{i}.product_id = products.id"
      where << "options_products#{i}.option_id IN (#{ids.join ','})"
    end
    @all_options_product_id = "products.id IN (SELECT DISTINCT products.id FROM products #{inner_join.join ' '} WHERE #{where.join ' AND '})"
  end

  def set_from_to
    @products = @products.join_price
    @from = @products.min
    @to = @products.max
    set_min_max
  end

  def set_min_max
    @price_from = params[:min]
    @products = @products.price_from @price_from if @price_from
    @price_to = params[:max]
    @products = @products.price_to @price_to if @price_to
    if @price_from or @price_to
      @options_products = @options_products.join_price
      @options_products = @options_products.price_from @price_from if @price_from
      @options_products = @options_products.price_to @price_to if @price_to
    end
    set_total_page
  end

  def set_total_page
    count = @products.count
    if count == 0
      @total_page = 1
    else
      @total_page = (count.to_f / @show).ceil
    end
    available_options
  end

  def available_options
    option_rows = Option.joins(:products).where(products: {id: @options_products.unscope(:select).select(:id)}).pluck(:id, :option_group_id)
    @available_options = {all: option_rows.map{|row| [row[0], true]}.to_h}

    if @checked_options.any?
      grouped_options = @grouped_options
      option_rows.map{|row| row[1]}.uniq.each do |current_group_id|
        @available_options[current_group_id] = Option.where(id: option_rows.find_all{|r| r[1] == current_group_id}.map{|r| r[0]}).where(
          grouped_options.except(current_group_id).map{|group_id, ids|
            ids.map{|id|
              "EXISTS (SELECT 1 FROM options_products WHERE options_products.product_id IN (SELECT product_id FROM options_products WHERE options_products.option_id = options.id) AND options_products.option_id = #{id})"
            }
          }.join(' AND ')
        ).pluck(:id).map{|row| [row, true]}.to_h
      end
    end
  end

  def set_page
    @page = params[:page].to_i
    @page = 1 if @page == 0
  end

  def set_show
    @show = params[:show].to_i
    @show = 12 if @show != 24 && @show != 36
  end

  def sort
    @sort = params[:sort]
    case @sort
    when 'priceAsc' then @products = @products.unscope(:order).order('retail_price ASC')
    when 'priceDesc' then @products = @products.unscope(:order).order('retail_price DESC')
    when 'popular' then @products = @products.unscope(:order).order('RANDOM()')
    else @sort = 'default'
    end
  end

  def set_parent
    @parent = Category.find_by(params[:column] => params[:url])
  end

  def set_category
    @category = Category.find_by(params[:column] => params[:category_url])
  end

  def option_product_map(option_ids)
    map = {}
    ActiveRecord::Base.connection.select_rows("SELECT product_id, option_id FROM options_products WHERE option_id IN (#{option_ids.join ','})").each do |row|
      product_id = row[0]
      m = map[product_id]
      if m
        m << row[1]
      else
        map[product_id] = [row[1]]
      end
    end
    map
  end

  def set_products
    @products = @products.limit(@show).offset((@page - 1) * @show).includes(:images)
  end

  def set_options
    options = Option.select(:id, :option_group_id, "value_#{locale}", :column, :priority).joins(:products).where(products: {id: @category.products.select(:id)}).uniq
    @option_groups = OptionGroup.where id: options.map(&:option_group_id)
    @options = @option_groups.map{|g| options.find_all{|o| o.option_group_id == g.id}}
  end
end
