class DropOldOptionsAndChangeProductPrice < ActiveRecord::Migration
  def change
    drop_table :options_groups
    drop_table :options
    drop_table :options_values
    change_column :products, :retail_price, :decimal, precision: 8, scale: 2
    change_column :products, :wholesale_price, :decimal, precision: 8, scale: 2
    change_column :products, :special_price, :decimal, precision: 8, scale: 2
    add_index :products, :active
  end
end
