class PagesController < ApplicationController
	ROOT_PAGES = ['MAIN_PAGE', 'CATALOG']
	
	before_action do
		c = Currency.select("title_#{I18n.locale.to_s}", :value, :constant_name)
		if id = cookies[:currency_id]
			$currency_id = id.to_i
			c = c.select(:constant_name, :value).find(id)
		else
			c = c.select(:id, :constant_name, :value).take
			$currency_id = c.id
		end
		$course = c.value
		$currency = c.constant_name
	end

	def show
		urls = params[:urls].split '/'
		urls_size = urls.size
		if urls_size > 1
			key = "url_#{I18n.locale}"

			pages = Page.active
				.select(:id, key, :parent_page_id)
				.where(key => urls)
				.order(urls.map{ |url| key + ' = ' + Page.sanitize(url) }.join(', '))

			pages[0...-1].each_with_index do |page, index|
				return render_404 unless pages[index + 1].id == page.parent_page_id
			end
		end

		@page = Page.local.with_products.find_by_url urls.last

		rend 'pages/show'

		# render_404
	    # if @product = is_product(params.try(:page_name))
	    #   @page = @product.base_page
	    #   if @page.try(locate_key(:url)) == params[:base_page]
	    #     return render "vkolgotkah/products/show"
	    #   end
	    # elsif @page = get_page_info(params[:page_name] || params[:base_page])
	    #   # Page has right params base page
	    #   parent_const_name = @page.parent.try(:constant_name)

	    #   if (params[:page_name] && @page.parent.try(locate_key(:url)) == params[:base_page] &&
	    #       @page[:constant_name] != parent_const_name && !ROOT_PAGES.include?(parent_const_name)) ||
	    #       # OR Page should have main parent page or catalog page
	    #      (!params[:page_name] && ROOT_PAGES.include?(parent_const_name))

	    #     return render "vkolgotkah/pages/show"
	    #   end
	    # else
	    #   return render_404
	    # end
	end

  def index
    @page = Page.local.where(constant_name: "MAIN_PAGE").first
    rend "home/index"
  end

  def categories
  	@category = Category.find_by(params[:column] => params[:url])
    rend "pages/categories"
  end

  def catalog
  	@curPage = params[:page].to_i
  	@curPage = 1 if @curPage == 0

  	@show = params[:show].to_i
  	@show = 12 if @show != 24 and @show != 36

  	@sort = params[:sort]

  	@parent = Category.find_by(params[:column] => params[:url])
  	@category = Category.find_by(params[:column] => params[:category_url])
  	records = @category.products.includes(:images)

	case @sort
	when 'priceAsc' then records = records.unscope(:order).order('retail_price ASC')
	when 'priceDesc' then records = records.unscope(:order).order('retail_price DESC')
	when 'popular' then records = records.unscope(:order).order('RANDOM()')
	else @sort = 'default'
	end

  	count = records.count
  	if count == 0
  		@totalPage = 1
  	else
  		@totalPage = (count.to_f / @show).ceil
  	end
  	@products = records.short.limit(@show).offset((@curPage - 1) * @show)
    rend "pages/catalog"
  end

  def catalog_json
	if show = params[:show]
		show = show.to_i
	else
		show = 12
	end
  	records = Product.where(category_id: params[:id])
		
	count = records.count

	records = records.select(:id, "title_#{I18n.locale}", :retail_price).limit(show)

	if page = params[:pageNumber]
		records = records.offset (page - 1) * show
	end

	case params[:sort]
	when 'priceAsc' then records = records.unscope(:order).order('retail_price ASC')
	when 'priceDesc' then records = records.unscope(:order).order('retail_price DESC')
	when 'popular' then records = records.unscope(:order).order('RANDOM()')
	end

	render plain: "{\"records\":#{records.includes(:images).to_json(include: :images)},\"totalPage\":#{(count.to_f / show).ceil}}"
  end

  private

  def get_page_info(curr_page)
    Page.where("#{locate_key(:url)} = ?", curr_page).first
  end

  def is_product(curr_page)
    Product.where("url_#{I18n.locale} = ?", curr_page).first
  end

end
