class Category < ActiveRecord::Base
  has_many :categories
  belongs_to :category

  has_many :products

  has_and_belongs_to_many :option_groups

  mount_uploader :image, CategoryUploader

  def url
    self["url_#{I18n.locale}"] || url_ru
  end

  def name
    self["name_#{I18n.locale}"] || name_ru
  end

  def text
    self["text_#{I18n.locale}"] || text_ru
  end
end
