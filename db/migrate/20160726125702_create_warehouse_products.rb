class CreateWarehouseProducts < ActiveRecord::Migration
  def change
    create_table :warehouse_products do |t|
    	t.belongs_to :warehouse, index: true
    	t.belongs_to :product, index: true
    	t.integer :quantity, default: 0, null: false
    	t.decimal :retail_price_changed, precision: 8, scale: 2, default: 0, null: false
    	t.decimal :wholesale_price_changed, precision: 8, scale: 2, default: 0, null: false
    	t.decimal :special_price_changed, precision: 8, scale: 2, default: 0, null: false
    end
  end
end
