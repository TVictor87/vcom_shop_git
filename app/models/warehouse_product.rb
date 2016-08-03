class WarehouseProduct < ActiveRecord::Base
	belongs_to :warehouse
	belongs_to :product
	has_many :option_warehouse_products
	has_and_belongs_to_many :options
end
