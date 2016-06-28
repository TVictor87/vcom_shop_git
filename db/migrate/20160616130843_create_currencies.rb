class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :title_ru
      t.string :title_uk
      t.string :title_en
      t.string :constant_name
      t.decimal :value, precision: 8, scale: 6
    end

    add_index :products, :retail_price_currency_id
    add_index :products, :wholesale_price_currency_id
    add_index :products, :special_price_currency_id
  end
end
