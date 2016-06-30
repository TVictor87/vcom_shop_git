module Admin
  class PagesController < Admin::BaseController
    before_action :set_page, only: [:show, :edit, :update, :destroy]

    # GET /pages
    def index
      @pages = Page.all
    end

    # GET /pages/1
    def show
    end

    # GET /pages/new
    def new
      @page = Page.new
    end

    # GET /pages/1/edit
    def edit
    end

    # POST /pages
    def create
      @page = Page.create(page_params)

      if @page.valid?
        redirect_to admin_pages_path, notice: t('admin.create.success')
      else
        redirect_to admin_pages_path, alert: @page.errors.messages
      end

      find_or_create_site_pages
    end

    # PATCH/PUT /pages/1
    def update
      # page = Page.find(params[:id])

      if @page.try(:update, page_params)
        redirect_to admin_page_path, notice: t('admin.update.success')
      else
        redirect_to edit_admin_page_path(page.id), alert: @page.errors.messages
      end

      # TODO: Analyze it in future
      SitePage.delete_all(page_id: @page.id)
      find_or_create_site_pages
    end

    # DELETE /pages/1
    def destroy
      @page.destroy
      redirect_to admin_pages_url, notice: t('admin.destroy.success')
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title_ru, :description_ru, :url_ru, :title_uk, :description_uk, :url_uk, :title_en, :description_en, :url_en, :constant_name, :parent_page_id, :active)
    end
  end

  protected

  def find_or_create_site_pages
    # TODO: Make in model
    params[:active_sites].each { |site_id| SitePage.find_or_create_by(page_id: @page.id, site_id: site_id) } if params[:active_sites]
  end
end
