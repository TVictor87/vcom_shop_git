class Option < ActiveRecord::Base
  belongs_to :option_group
  has_and_belongs_to_many :warehouse_products
  has_and_belongs_to_many :products

  def value
    self["value_#{I18n.locale}"] || value_ru
  end
end
