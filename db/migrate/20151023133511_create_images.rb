class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      image(t)
      t.integer :priority, null: false, default: 0

      t.timestamps null: false
    end
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
end
