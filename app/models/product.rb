class Product < ActiveRecord::Base
  # :title_uk, :description_uk, :url_uk,
  # :title_en, :description_en, :url_en,
  # :retail_price, :retail_price_currency_id,
  # :wholesale_price, :wholesale_price_currency_id,
  # :special_price, :special_price_currency_id,
  # :special_link_id, :active

  default_scope { where(active: true) }
  scope :join_price, -> { joins(:retail_price_currency) }
  scope :min, lambda {
    min = unscope(:order).select('min(products.retail_price * currencies.value) as retail_price')
    min[0] ? (min[0].retail_price / Currency.course).floor : 0
  }
  scope :max, lambda {
    max = unscope(:order).select('max(products.retail_price * currencies.value) as retail_price')
    max[0] ? (max[0].retail_price / Currency.course).ceil : 0
  }
  scope :select_few, -> { select("products.id, products.retail_price * currencies.value as retail_price, products.title_#{I18n.locale}") }
  scope :price_from, -> (min) { where('products.retail_price * value >= ?', min.to_f / Currency.course) }
  scope :price_to, -> (max) { where('products.retail_price * value <= ?', max.to_f / Currency.course) }

  belongs_to :category

  belongs_to :retail_price_currency, class_name: 'Currency'

  has_and_belongs_to_many :pages
  has_many :site_products, dependent: :destroy
  has_many :sites, through: :site_products
  has_many :images, dependent: :destroy
  has_many :warehouse_products
  has_and_belongs_to_many :options

  validates :title_ru, presence: true, length: { minimum: 2 }
  # validates :description_ru, presence: true, length: { minimum: 5 }
  validates :url_ru, presence: true, uniqueness: true
  validates :retail_price, null: false
  validates :retail_price_currency_id, null: false

  def title
    self["title_#{I18n.locale}"] || title_ru
  end

  def price
    case Currency.currency
    when 'UAH'
      format('<b>%.2f</b> грн', (retail_price / Currency.course)).gsub(/\B(?=(\d{3})+(?!\d))/, ' ')
    when 'USD'
      format('$<b>%.2f</b>', (retail_price / Currency.course)).gsub(/\B(?=(\d{3})+(?!\d))/, ' ')
    end
  end
end
