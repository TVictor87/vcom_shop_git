class PagesController < ApplicationController
  ROOT_PAGES = %w(MAIN_PAGE CATALOG)

  before_action do
    c = Currency.select("title_#{I18n.locale}", :value, :constant_name)
    id = cookies[:currency_id]
    if id
      find = c.select(:constant_name, :value).find_by_id(id)
      if find
        Currency.currency_id = id.to_i
        c = find
      else
        c = c.select(:id, :constant_name, :value).take
        Currency.currency_id = c.id
      end
    else
      c = c.select(:id, :constant_name, :value).take
      Currency.currency_id = c.id
    end
    Currency.course = c.value
    Currency.currency = c.constant_name
  end

  def show
    if _show params[:urls].split '/'
      rend 'pages/show'
    else
      render_404
    end
  end

  def index
    @page = Page.local.where(constant_name: 'MAIN_PAGE').first
    rend 'home/index'
  end

  protected

  def _show(urls)
    if urls.size > 1
      pages = show_pages urls

      pages[0...-1].each_with_index do |page, index|
        return false unless pages[index + 1].id == page.parent_page_id
      end
    end

    @page = Page.local.with_products.find_by_url urls.last
    true
  end

  def show_pages(urls)
    key = "url_#{I18n.locale}"

    Page.active
      .select(:id, key, :parent_page_id)
      .where(key => urls)
      .order(urls.map { |url| key + ' = ' + Page.sanitize(url) }.join(', '))
  end
end
