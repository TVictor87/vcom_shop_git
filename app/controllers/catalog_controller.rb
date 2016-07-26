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
    get_products @category.id

    @products = @products.select_few

    sort
    set_products
    set_options

    rend 'catalog/catalog'
  end

  def catalog_json
    get_products params[:id].to_i

    @products = @products.select_few

    sort
    set_products

    render json: "{\"records\":#{@products.to_json(include: :images)},\"totalPage\":#{@total_page},\"min\":#{@from},\"max\":#{@to},\"available_options\":#{@available_options.to_json}}"
  end

  private

  def get_products id
    @category_id = id
    condition = "products.category_id = #{id}"
    @where = [condition]
    @products = Product.where(condition)
    filter_by_options
  end

  def filter_by_options
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
    @options_with_products = Option.joins(:products).where(products: {category_id: @category_id})
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
      @options_with_products = @options_with_products.joins(products: :retail_price_currency)
      @options_with_products = @options_with_products.where('products.retail_price * value >= ?', @price_from.to_f / Currency.course) if @price_from
      @options_with_products = @options_with_products.where('products.retail_price * value <= ?', @price_to.to_f / Currency.course) if @price_to
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
    @available_options = {all: @options_with_products.pluck(:id).map{|id| [id, true]}.to_h}
    if @checked_options.any?
      finded_option_ids = {} # Чтобы id в groups не дублировались
      groups = {} # Hash [id группы] => [массив id опций в этой группе]
      product_ids = {} # Hash [id товара] => индекс массива id опций в products
      products = [] # [[]] Массив массивов id опций в каждом найденом товаре
      @options_with_products.pluck(:id, :option_group_id, :product_id).each do |row| # Выборка ключевых id из ранее отфильтрованных опций
        id, product_id = row[0], row[2]
        unless finded_option_ids[id] # если ещё не было этой опции
          finded_option_ids[id] = true # запоминаем её
          option_group_id = row[1]
          groups[option_group_id] and groups[option_group_id] << id or groups[option_group_id] = [id] # добавляем id в группу или создаем её с этим id
        end
        i = product_ids[product_id]
        if i # Если уже был этот товар
          products[i] << id # Добавляем id его опции в его коллекцию
        else # А если ещё не было
          i = products.size # Берем индекс нового массива для id опций
          product_ids[product_id] = i # Запоминаем какой индекс у какого товара
          products[i] = [id] # Инициализируем массив id опций для этого товара
        end
      end
      available_options_map @grouped_options, groups, products
    end
  end

  def available_options_map grouped_options, groups, products
    available_options = @available_options # Так быстрее к переменной обращаться
    groups.each{|current_group_id, current_option_ids| # Текущая группа и текущие id опций
      available_options[current_group_id] = current_option_ids.map{|current_id| # id текущей опции
        [current_id, grouped_options.except(current_group_id).all?{|checked_group_id, checked_option_ids| # Отмеченная группа, кроме текущей, и id отмеченных опций в ней
          checked_option_ids.all?{|checked_id| # id выбранной опции внутри группы
            products.any?{|ids| ids.include?(checked_id) and ids.include?(current_id)} # Если хоть в одном из товаров одновременно нет текущей опции и отмеченной, значит, текущая недоступна
          }
        }]
      }.to_h
    }
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
