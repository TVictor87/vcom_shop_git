class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :title_ru
      t.string :title_uk
      t.string :title_en
      t.string :constant_name
    end
  end
end
