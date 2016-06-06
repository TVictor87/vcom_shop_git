class CreatePageProducts < ActiveRecord::Migration
  def change
    create_table :page_products do |t|
      t.integer :page_id
      t.integer :product_id
    end
  end
end
