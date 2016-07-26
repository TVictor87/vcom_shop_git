module Admin
  class CategoriesController < Admin::BaseController
    before_action :set_category, only: [:show, :edit, :update, :destroy]

    # GET /pages
    def index
      @categories = Category.all
    end

    # GET /pages/1
    def show
    end

    # GET /pages/new
    def new
      @category = Category.new
    end

    # GET /pages/1/edit
    def edit
    end

    # POST /pages
    def create
      @category = Category.create(category_params)

      if @category.valid?
        redirect_to admin_categories_path, notice: t('admin.create.success')
      else
        redirect_to admin_categories_path, alert: @category.errors.messages
      end
    end

    # PATCH/PUT /pages/1
    def update
      if @category.try(:update, category_params)
        redirect_to admin_categories_path, notice: t('admin.update.success')
      else
        redirect_to edit_admin_category_path(@category.id), alert: @category.errors.messages
      end
    end

    # DELETE /pages/1
    def destroy
      @category.destroy
      redirect_to admin_categories_url, notice: t('admin.destroy.success')
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the internet, only allow the white list through.
    def category_params
      params.require(:category).permit(
        :category_id, :priority, :image, :alt_ru, :title_ru, :alt_uk, :title_uk, :alt_en, :title_en, :name_ru, :name_uk, :name_en, :title_ru, :title_uk, :title_en, :keywords_ru, :keywords_uk, :keywords_en, :description_ru, :description_uk, :description_en, :text_ru, :text_uk, :text_en, :url_ru, :url_uk, :url_en, option_group_ids: []
      )
    end
  end
end
