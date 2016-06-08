class PagesController < ApplicationController
	ROOT_PAGES = ['MAIN_PAGE', 'CATALOG']

	def show
		urls = params[:urls].split '/'
		urls_size = urls.size
		if urls_size > 1
			key = "url_#{I18n.locale}"
			pages = Page.unscope(:select).select(:id, key, :parent_page_id).where(key => urls)
			pages.each_with_index do |page, index|
				if parent_page_id = page.parent_page_id
					return render_404 unless pages.find { |page| page.id == parent_page_id }
				end
			end
		end

		@page = Page.find_by_url urls.last

		rend "pages/show"

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
    @page = Page.where(constant_name: "MAIN_PAGE").first
    render "vkolgotkah/home/index"
  end

  private

  def get_page_info(curr_page)
    Page.where("#{locate_key(:url)} = ?", curr_page).first
  end

  def is_product(curr_page)
    Product.where("url_#{I18n.locale} = ?", curr_page).first
  end

end
