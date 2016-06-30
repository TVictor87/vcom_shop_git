require 'rmagick'

class CategoryUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    "uploads/images/categories/#{model.id}"
  end

  version :main do
    process resize_to_fill: [307, 307]
  end
end
