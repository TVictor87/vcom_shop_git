class Image < ActiveRecord::Base
  has_one :product_image
  has_one :product, through: :product_image

  mount_uploader :image, ImageUploader

  validates :image, presence: true
  validates :title_ru, :alt_ru, presence: true, length: { minimum: 2 }
end
