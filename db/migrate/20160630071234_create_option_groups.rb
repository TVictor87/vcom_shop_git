class CreateOptionGroups < ActiveRecord::Migration
  def change
    create_table :option_groups do |t|
      t.string :title_ru
      t.string :title_uk
      t.string :title_en
      t.string :field_type
      t.boolean :required, null: false, default: false
      t.boolean :active, null: false, default: false
      t.integer :columns, default: 1
      t.integer :priority, null: false, default: 0
      t.boolean :visible, null: false, default: true
    end
  end
end
