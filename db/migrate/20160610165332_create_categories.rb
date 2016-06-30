class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.belongs_to :category, index: true
      t.integer :priority, default: 0

      urls(t)
      image(t)
      names_and_titles(t)
      fields(t)

      t.timestamps null: false
    end

    add_column :products, :category_id, :integer, index: true
  end

  def urls(t)
    t.string :categories, :url_ru, index: true
    t.string :categories, :url_uk, index: true
    t.string :categories, :url_en, index: true
  end

  def image(t)
    t.string :image
    t.string :alt_ru
    t.string :title_ru
    t.string :alt_uk
    t.string :title_uk
    t.string :alt_en
    t.string :title_en
  end

  def names_and_titles(t)
    t.string :name_ru
    t.string :name_uk
    t.string :name_en
    t.string :title_ru
    t.string :title_uk
    t.string :title_en
  end

  def fields(t)
    t.string :keywords_ru
    t.string :keywords_uk
    t.string :keywords_en
    t.text :description_ru
    t.text :description_uk
    t.text :description_en
    t.text :text_ru
    t.text :text_uk
    t.text :text_en
  end
end
