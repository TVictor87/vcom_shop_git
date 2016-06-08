class Page < ActiveRecord::Base
  key = I18n.locale.to_s
  title = 'title_' + key
  description = 'description_' + key
  url = 'url_' + key

  default_scope { where(active: true).select title, description }

  has_many :site_pages, dependent: :destroy
  has_many :sites, through: :site_pages

  # TODO: Add validation that page couldn't has parent itself
  belongs_to :page, :foreign_key => "parent_page_id"
  has_many :pages, :foreign_key => "parent_page_id"
  # belongs_to :page

  has_many :page_products, dependent: :destroy
  has_many :products, through: :page_products
  # validates :title_ru, :url_ru, :title_uk, :url_uk, :title_en,
  #           :url_en, length: { minimum: 2, :allow_nil => true }
  validates :constant_name, presence: true

  find_by_url = 'find_by_url_' + key
  def self.find_by_url url
    send find_by_url, url
  end
end