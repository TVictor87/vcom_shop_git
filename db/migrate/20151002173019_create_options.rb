class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      fields(t)
    end
  end

  def fields(t)
    t.integer :options_group_id, null: false
    t.string :title_ru
    t.string :title_uk
    t.string :title_en
    t.string :field_type
    t.boolean :required, null: false, default: false
    t.boolean :is_active, null: false, default: false
    t.integer :priority

    t.timestamps null: false
  end
end
