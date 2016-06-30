class RemoveProductImages < ActiveRecord::Migration
  def change
    drop_table :product_images
    add_reference :images, :product, index: true
  end
end
