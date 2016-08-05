class OptionWarehouseProduct < ActiveRecord::Base
	belongs_to :option
	belongs_to :warehouse_product
	self.table_name = "options_warehouse_products"
end
