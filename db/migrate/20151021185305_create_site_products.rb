class CreateSiteProducts < ActiveRecord::Migration
  def change
    create_table :site_products do |t|
      t.integer :site_id
      t.integer :product_id
    end
  end
end
