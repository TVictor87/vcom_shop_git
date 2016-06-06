class CreateSitePages < ActiveRecord::Migration
  def change
    create_table :site_pages do |t|
      t.integer :site_id
      t.integer :page_id
    end
  end
end
