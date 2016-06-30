class CreateOptionGroups < ActiveRecord::Migration
  def change
    create_table :option_groups do |t|
      t.string :title_ru
      t.string :title_uk
      t.string :title_en
      t.boolean :active
    end
  end
end
