class Product < ActiveRecord::Base
  # :title_uk, :description_uk, :url_uk,
  # :title_en, :description_en, :url_en,
  # :retail_price, :retail_price_currency_id,
  # :wholesale_price, :wholesale_price_currency_id,
  # :special_price, :special_price_currency_id,
  # :special_link_id, :active

  default_scope { where(active: true).order(:priority) }
  scope :short, -> { select("products.id, retail_price * value as retail_price, products.title_ru").joins(:retail_price_currency) }

  belongs_to :category

  belongs_to :retail_price_currency, class_name: "Currency"

  has_and_belongs_to_many :pages
  has_many :site_products, dependent: :destroy
  has_many :sites, through: :site_products
  has_many :images, dependent: :destroy

  validates :title_ru, presence: true, length: { minimum: 2 }
  # validates :description_ru, presence: true, length: { minimum: 5 }
  validates :url_ru, presence: true, uniqueness: true

  def title
    self["title_#{I18n.locale.to_s}"] or title_ru
  end

  def price
    case $currency
    when 'UAH'
      ('<b>%.2f</b> грн' % (retail_price / $course)).gsub(/\B(?=(\d{3})+(?!\d))/, ' ')
    when 'USD'
      ('$<b>%.2f</b>' % (retail_price / $course)).gsub(/\B(?=(\d{3})+(?!\d))/, ',')
    end
  end
end
