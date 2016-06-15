# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/images/products/#{model.product.id}"
  end

  version :small do
    process resize_to_fit: [70, 97]
  end

  version :medium do
    process resize_to_fit: [226, 311]
  end

  version :big do
    process resize_to_fit: [312, 436]
  end
end
