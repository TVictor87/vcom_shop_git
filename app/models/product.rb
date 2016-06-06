class Product < ActiveRecord::Base
  # :title_uk, :description_uk, :url_uk,
  # :title_en, :description_en, :url_en,
  # :retail_price, :retail_price_currency_id,
  # :wholesale_price, :wholesale_price_currency_id,
  # :special_price, :special_price_currency_id,
  # :special_link_id, :active

  belongs_to :base_page, class_name: Page

  has_many :page_products, dependent: :destroy
  has_many :pages, through: :page_products
  has_many :site_products, dependent: :destroy
  has_many :sites, through: :site_products
  has_many :product_images, dependent: :destroy
  has_many :images, through: :product_images

  validates :title_ru, presence: true, length: { minimum: 2 }
  # validates :description_ru, presence: true, length: { minimum: 5 }
  validates :url_ru, presence: true, uniqueness: true
  validates :base_page_id, :site_ids, :page_ids, presence: true
end
