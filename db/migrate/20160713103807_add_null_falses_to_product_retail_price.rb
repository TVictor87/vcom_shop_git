class AddNullFalsesToProductRetailPrice < ActiveRecord::Migration
  def change
  	change_column :products, :retail_price, :float, null: false
  	change_column :products, :retail_price_currency_id, :integer, null: false
  end
end
