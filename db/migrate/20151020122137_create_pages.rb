class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title_ru
      t.text :description_ru
      t.string :url_ru
      t.string :title_uk
      t.text :description_uk
      t.string :url_uk
      t.string :title_en
      t.text :description_en
      t.string :url_en
      t.string :constant_name
      t.integer :parent_page_id
      t.boolean :active, null: false, default: true
    end
  end
end
