class Site < ActiveRecord::Base
  has_many :pages, through: :site_pages
  has_many :products, through: :site_products
  #
  # validates :title_ru, :title_uk, :title_en, length: { minimum: 2, :allow_nil => true }
end
