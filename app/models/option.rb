class Option < ActiveRecord::Base
  include I18nable
  belongs_to :option_group
  has_and_belongs_to_many :warehouse_products
  has_and_belongs_to_many :products
end
