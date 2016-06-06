class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title_ru
      t.text :description_ru
      t.string :url_ru
      t.string :title_uk
      t.text :description_uk
      t.string :url_uk
      t.string :title_en
      t.text :description_en
      t.string :url_en
      t.integer :priority, null: false, default: 0
      t.integer :base_page_id
      t.float :retail_price
      t.integer :retail_price_currency_id
      t.float :wholesale_price
      t.integer :wholesale_price_currency_id
      t.float :special_price
      t.integer :special_price_currency_id
      t.integer :special_link_id
      t.boolean :active, null: false, default: true

      t.timestamps null: false
    end
  end
end
