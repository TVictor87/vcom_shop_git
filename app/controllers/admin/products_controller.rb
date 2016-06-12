module Admin
  class ProductsController < Admin::BaseController
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def index
      @products = Product.unscope :where
    end

    def new
      @product = Product.new
    end

    def create
      product = Product.create(product_params)

      if product.valid?
        redirect_to admin_products_path, notice: t('admin.create.success')
      else
        redirect_to new_admin_product_path, alert: product.errors.messages
      end
    end

    def show
    end

    def edit
    end

    def update
      if @product.try(:update, product_params)
        redirect_to admin_products_path, notice: t('admin.update.success')
      else
        redirect_to edit_admin_product_path(@product.id), alert: @product.errors.messages
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: t('admin.destroy.success')
    end

    private

    def set_product
      @product = Product.find(params[:product_id] || params[:id])
    end

    def product_params
      params.require(:product).permit(
        :category_id,
        :title_ru, :description_ru, :url_ru,
        :title_uk, :description_uk, :url_uk,
        :title_en, :description_en, :url_en,
        :retail_price, :retail_price_currency_id,
        :wholesale_price, :wholesale_price_currency_id,
        :special_price, :special_price_currency_id,
        :special_link_id, :active, :base_page_id, :priority,
        site_ids: [], page_ids: []
      )
    end
  end
end
