module Admin
  class WarehouseProductsController < Admin::BaseController
    before_action :set_warehouse_product, only: [:update, :destroy]

    def create
      @warehouse_product = WarehouseProduct.new warehouse_product_params
      if uniq(params[:option_ids])
        @warehouse_product.save
        render text: 'ok'
      else
        render nothing: true, status: 422
      end
    end

    def update
      option_ids = params[:option_ids]
      current_ids = @warehouse_product.option_ids
      if (current_ids == option_ids or current_ids == option_ids.reverse) or uniq(option_ids)
        @warehouse_product.update warehouse_product_params
        render text: 'ok'
      else
        render nothing: true, status: 422
      end
    end

    def destroy
      @warehouse_product.destroy
      render text: 'ok'
    end

    private

    def uniq(ids)
      not WarehouseProduct.where("warehouse_id = #{@warehouse_product.warehouse_id} AND product_id = #{@warehouse_product.product_id} AND EXISTS (SELECT 1 FROM options_warehouse_products a WHERE a.warehouse_product_id = warehouse_products.id AND a.option_id = #{ids[0].to_i}) AND EXISTS (SELECT 1 FROM options_warehouse_products a WHERE a.warehouse_product_id = warehouse_products.id AND a.option_id = #{ids[1].to_i})").exists?
    end

    def warehouse_product_params
      params.permit(:quantity, :retail_price_changed, :product_id, :warehouse_id, option_ids: [])
    end

    def set_warehouse_product
      @warehouse_product = WarehouseProduct.find(params[:id])
    end
  end
end
