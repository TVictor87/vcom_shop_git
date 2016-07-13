class CatalogController < PagesController
  before_action :set_page
  before_action :set_show
  before_action :set_parent, only: :catalog
  before_action :set_category, only: :catalog

  def categories
    @category = Category.find_by(params[:column] => params[:url])
    rend 'catalog/categories'
  end

  def catalog
    @products = @category.products.join_price
    
    filter_by_options

    set_from_to
    set_min_max
    set_total_page
    available_options

    @products = @products.select_few

    sort
    set_products
    set_options

    if @available_options
      a = {}
      @available_options.each do |k| a[k] = true end
      @available_options = a
    end

    rend 'catalog/catalog'
  end

  def catalog_json
    @products = Product.where(category_id: params[:id]).join_price
    
    filter_by_options

    set_from_to
    set_min_max
    set_total_page
    available_options

    @products = @products.select_few

    sort
    set_products

    render json: "{\"records\":#{@products.to_json(include: :images)},\"totalPage\":#{@total_page},\"min\":#{@from},\"max\":#{@to},\"available_options\":#{@available_options.to_json}}"
  end

  private

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

  def set_from_to
    @from = @products.min
    @to = @products.max
  end

  def set_min_max
    @price_from = params[:min]
    @products = @products.price_from @price_from if @price_from
    @price_to = params[:max]
    @products = @products.price_to @price_to if @price_to
  end

  def set_total_page
    count = @products.count
    if count == 0
      @total_page = 1
    else
      @total_page = (count.to_f / @show).ceil
    end
  end

  def filter_by_options
    @checked_options = params[:options]
    if @checked_options
      @checked_options.map!(&:to_i)
      map = {}
      ActiveRecord::Base.connection.select_rows("SELECT product_id, option_id FROM options_products WHERE option_id IN (#{@checked_options.join ','})").each do |row|
        product_id = row[0]
        m = map[product_id]
        if m
          m << row[1]
        else
          map[product_id] = [row[1]]
        end
      end
      count = @checked_options.count
      ids = []
      for product_id, option_ids in map
        ids << product_id if option_ids.count == count
      end
      @products = @products.where(id: ids)
    else
      @checked_options = []
    end
  end

  def set_products
    @products = @products.limit(@show).offset((@page - 1) * @show).includes(:images)
  end

  def set_options
    options = Option.select(:id, :option_group_id, "value_#{locale}", :column, :priority).joins(:option_group, :products).where(option_groups: {active: false}, products: {id: @category.products.select(:id)}).uniq
    @option_groups = OptionGroup.where id: options.map(&:option_group_id)
    @options = @option_groups.map{|g| options.find_all{|o| o.option_group_id == g.id}}
  end

  def available_options
    if @checked_options.any?
      @available_options = Option.joins(:products).where(products: {id: @products.unscope(:select, :joins).joins(:options).where(options: {id: params[:options]})}).pluck(:id).uniq
    else
      @available_options = nil
    end
  end
end
