module Admin
  class SitesController < Admin::BaseController
    before_action :set_site, only: [:show, :edit, :update, :destroy]

    # GET /sites
    def index
      @sites = Site.all
    end

    # GET /sites/1
    def show
    end

    # GET /sites/new
    def new
      @site = Site.new
    end

    # GET /sites/1/edit
    def edit
    end

    # POST /sites
    def create
      @site = Site.create(site_params)

      if @site.valid?
        redirect_to admin_sites_path, notice: t('admin.create.success')
      else
        redirect_to admin_sites_path, alert: @site.errors.messages
      end
    end

    # PATCH/PUT /sites/1
    def update
      if @site.try(:update, site_params)
        redirect_to admin_site_path, notice: t('admin.update.success')
      else
        redirect_to edit_admin_site_path(@site.id), alert: @site.errors.messages
      end
    end

    # DELETE /sites/1
    # DELETE /sites/1.json
    def destroy
      @site.destroy
      redirect_to admin_sites_url, notice: t('admin.destroy.success')
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
    end

    # Never trust parameters from the internet, only allow the white list through.
    def site_params
      params.require(:site).permit(:title_ru, :title_uk, :title_en, :constant_name)
    end
  end
end
