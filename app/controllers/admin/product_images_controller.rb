module Admin
  class ProductImagesController < Admin::ProductsController
    before_action :set_product

    def new
      @image = Image.new
    end

    def create
      image = @product.images.create(image_params)

      if image.valid?
        redirect_to edit_admin_product_path(@product.id) + '#img', notice: t('admin.create.success')
      else
        redirect_to new_admin_product_product_image_path(@product.id), alert: image.errors.messages
      end
    end

    def destroy
      @product.images.destroy(params[:id])
      redirect_to edit_admin_product_path(@product.id) + '#img', notice: t('admin.destroy.success')
    end

    private

    def image_params
      params.require(:image).permit(:title_ru, :alt_ru, :title_uk, :alt,
                                    :title_en, :alt_en, :image, :priority)
    end
  end
end
