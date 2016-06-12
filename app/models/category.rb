class Category < ActiveRecord::Base
	has_many :categories
	belongs_to :category

	mount_uploader :image, CategoryUploader

	def url
		self["url_#{I18n.locale.to_s}"] or url_ru
	end

	def name
		self["name_#{I18n.locale.to_s}"] or name_ru
	end
end
