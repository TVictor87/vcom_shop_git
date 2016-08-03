module Admin
  class WarehouseProductsController < Admin::BaseController
    before_action :set_warehouse_product, only: [:update, :destroy]

    def create
      @warehouse_product = WarehouseProduct.new warehouse_product_params
      if uniq(params[:option_ids])
        @warehouse_product.save
        add_options
        render text: 'ok'
      else
        render nothing: true, status: 422
      end
    end

    def update
      option_ids = params[:option_ids]
      @current_ids = @warehouse_product.option_ids
      options_not_changed = (@current_ids == option_ids or @current_ids == option_ids.reverse)
      if options_not_changed or uniq(option_ids)
        @warehouse_product.update warehouse_product_params
        unless options_not_changed
          remove_options
          add_options
        end
        render text: 'ok'
      else
        render nothing: true, status: 422
      end
    end

    def destroy
      @current_ids = @warehouse_product.option_ids
      @option_ids = []
      @product_id = @warehouse_product.product_id
      remove_options
      @warehouse_product.destroy
      render text: 'ok'
    end

    private

    def uniq(ids)
      @option_ids = ids
      @product_id = @warehouse_product.product_id
      not WarehouseProduct.where(
        "warehouse_id = #{@warehouse_product.warehouse_id} AND "\
        "product_id = #{@product_id} AND "\
        "EXISTS ("\
          "SELECT 1 FROM options_warehouse_products a "\
          "WHERE a.warehouse_product_id = warehouse_products.id AND "\
          "a.option_id = #{ids[0].to_i}"\
        ") AND EXISTS ("\
          "SELECT 1 FROM options_warehouse_products a WHERE "\
          "a.warehouse_product_id = warehouse_products.id AND "\
          "a.option_id = #{ids[1].to_i}"\
        ")"
      ).exists?
    end

    def remove_options
      @current_ids.each do |id|
        unless @option_ids.include?(id)
          OptionProduct.where("options_products.option_id = #{id} AND options_products.product_id = #{@product_id} AND NOT EXISTS (SELECT 1 FROM options WHERE options.id = #{id} AND EXISTS (SELECT 1 FROM option_groups og WHERE og.id = options.option_group_id AND og.active = 'f'))").delete_all
        end
      end
    end

    def add_options
      @option_ids.each do |id|
        if nil == ActiveRecord::Base.connection.select_value("SELECT 1 FROM options_products op WHERE op.product_id = #{@product_id} AND op.option_id = #{id}")
          ActiveRecord::Base.connection.execute("INSERT INTO options_products (option_id, product_id) VALUES (#{id}, #{@product_id})")
        end
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
