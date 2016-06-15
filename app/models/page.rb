class Page < ActiveRecord::Base

  scope :active, -> { where(active: true) }
  scope :local, -> { where(active: true).select :id, "title_#{I18n.locale.to_s}", "description_#{I18n.locale.to_s}" }
  scope :with_products, -> { includes(products: :images) }

  has_many :site_pages, dependent: :destroy
  has_many :sites, through: :site_pages

  # TODO: Add validation that page couldn't has parent itself
  belongs_to :page, foreign_key: :parent_page_id
  has_many :pages, foreign_key: :parent_page_id
  # belongs_to :page

  has_and_belongs_to_many :products
  has_many :base_products, foreign_key: :base_page_id, class_name: 'Product'
  # validates :title_ru, :url_ru, :title_uk, :url_uk, :title_en,
  #           :url_en, length: { minimum: 2, :allow_nil => true }
  validates :constant_name, presence: true

  def self.find_by_url url
    send "find_by_url_#{I18n.locale.to_s}", url
  end

  def description
    self["description_#{I18n.locale.to_s}"] or description_ru
  end
end