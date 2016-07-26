class CreateWarehouses < ActiveRecord::Migration
  def change
    create_table :warehouses do |t|
    	t.string :name
    end
  end
end
