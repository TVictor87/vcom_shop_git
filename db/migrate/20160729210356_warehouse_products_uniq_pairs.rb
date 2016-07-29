class WarehouseProductsUniqPairs < ActiveRecord::Migration
  def change
  	add_index :options_warehouse_products, [:warehouse_product_id, :option_id], unique: true, name: 'o_wp_uniq'
  end
end
