class CreateOptionsGroup < ActiveRecord::Migration
  def change
    create_table :options_groups do |t|
      t.string :title_ru
      t.string :title_uk
      t.string :title_en
      t.string :constant_name

      t.timestamps null: false
    end
  end
end
