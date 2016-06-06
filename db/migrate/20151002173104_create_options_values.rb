class CreateOptionsValues < ActiveRecord::Migration
  def change
    create_table :options_values do |t|
      t.integer :option_id, null: false
      t.string :title_ru
      t.string :title_uk
      t.string :title_en

      t.timestamps null: false
    end
  end
end
