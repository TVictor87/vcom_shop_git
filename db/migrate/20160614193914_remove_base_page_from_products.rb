class RemoveBasePageFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :base_page_id
  end
end
