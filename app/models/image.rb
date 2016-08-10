class Image < ActiveRecord::Base
  include I18nable
  default_scope { order(:priority) }
  belongs_to :product

  mount_uploader :image, ImageUploader

  validates :image, presence: true
  validates :title_ru, :alt_ru, presence: true, length: { minimum: 2 }
end
