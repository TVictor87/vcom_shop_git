class CreateWarehouseProductOptions < ActiveRecord::Migration
  def change
    create_join_table :warehouse_products, :options do |t|
		t.index :warehouse_product_id
		t.index :option_id
	end
  end
end
