require 'rmagick'

class CategoryUploader < CarrierWave::Uploader::Base

  def store_dir
    "uploads/images/categories/#{model.id}"
  end
end
