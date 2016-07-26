class ChangePageProducts < ActiveRecord::Migration
  def change
    rename_table :page_products, :pages_products
    add_index :pages_products, :page_id
    add_index :pages_products, :product_id
    add_index :products, :base_page_id
  end
end
