class Category < ActiveRecord::Base
  include I18nable
  has_many :categories
  belongs_to :category

  has_many :products

  has_and_belongs_to_many :option_groups

  mount_uploader :image, CategoryUploader
end
