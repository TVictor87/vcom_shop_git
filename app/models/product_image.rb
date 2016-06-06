class ProductImage < ActiveRecord::Base
  belongs_to :product
  belongs_to :image, dependent: :destroy
end
