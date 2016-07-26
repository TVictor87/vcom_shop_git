class CreateOptions2 < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.belongs_to :option_group, index: true
      t.string :value_ru
      t.string :value_uk
      t.string :value_en
      t.decimal :retail_price, precision: 8, scale: 2
      t.belongs_to :retail_price_currency, index: true
      t.integer :column, default: 1
      t.integer :priority, null: false, default: 0
    end

    create_join_table :options, :products do |t|
      t.index [:option_id, :product_id], name: 'o_p_index'
      t.index [:product_id, :option_id], name: 'p_o_index'
    end
  end
end