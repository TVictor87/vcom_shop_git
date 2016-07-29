module Admin
  class WarehouseProductsController < Admin::BaseController
    before_action :set_warehouse_product, only: [:destroy]

    def destroy
      @warehouse_product.destroy
      render text: 'ok'
    end

    private

    def set_warehouse_product
      @warehouse_product = WarehouseProduct.find(params[:id])
    end
  end
end
