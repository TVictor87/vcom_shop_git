module Admin
  class WarehouseProductsController < Admin::BaseController
    before_action :set_warehouse_product, only: [:update, :destroy]

    def update
      @warehouse_product.update warehouse_product_params
      render text: 'ok'
    end

    def destroy
      @warehouse_product.destroy
      render text: 'ok'
    end

    private

    def warehouse_product_params
      params.permit(:quantity, :retail_price_changed, option_ids: [])
    end

    def set_warehouse_product
      @warehouse_product = WarehouseProduct.find(params[:id])
    end
  end
end
