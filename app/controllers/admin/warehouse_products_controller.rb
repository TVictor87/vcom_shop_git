module Admin
  class WarehouseProductsController < Admin::BaseController
    before_action :set_warehouse_product, only: [:update, :destroy]

    def create
      @warehouse_product = WarehouseProduct.new warehouse_product_params
      if uniq(params[:option_ids])
        @warehouse_product.save
        get_ids
        save_options
        render text: 'ok'
      else
        render nothing: true, status: 422
      end
    end

    def update
      option_ids = params[:option_ids]
      @current_ids = @warehouse_product.option_ids
      if (@current_ids == option_ids or @current_ids == option_ids.reverse) or uniq(option_ids)
        @warehouse_product.update warehouse_product_params
        remove_old_ids
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
      @option_ids = ids
      @product_id = @warehouse_product.product_id
      not WarehouseProduct.where("warehouse_id = #{@warehouse_product.warehouse_id} AND product_id = #{@product_id} AND EXISTS (SELECT 1 FROM options_warehouse_products a WHERE a.warehouse_product_id = warehouse_products.id AND a.option_id = #{ids[0].to_i}) AND EXISTS (SELECT 1 FROM options_warehouse_products a WHERE a.warehouse_product_id = warehouse_products.id AND a.option_id = #{ids[1].to_i})").exists?
    end

    def get_ids
      @all_ids = Option.joins(options_products: {product_id: @product_id}).pluck(:id)
    end

    def remove_old_ids
      get_ids
      @current_ids.each do |id|
        unless @option_ids.include?(id)
          if not Option.joins(:warehouse_products).where(warehouse_products: {product_id: @product_id}, id: id)
            @all_ids.delete(id)
          end
        end
      end
      save_options
    end

    def save_options
      first = @all_ids.include?(@option_ids.first)
      second = @all_ids.include?(@option_ids.second)
      if first or second
        @all_ids << first if first
        @all_ids << second if second
        Product.update(@product_id, {option_ids: @all_ids})
      end
    end

    def warehouse_product_params
      params.permit(:quantity, :retail_price_changed, :product_id, :warehouse_id, option_ids: [])
    end

    def set_warehouse_product
      @warehouse_product = WarehouseProduct.find(params[:id])
    end
  end
end
