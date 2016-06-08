class Image < ActiveRecord::Base
	default_scope { order(:priority) }
	belongs_to :product

	mount_uploader :image, ImageUploader

	validates :image, presence: true
	validates :title_ru, :alt_ru, presence: true, length: { minimum: 2 }

	def title
		self["title_#{I18n.locale.to_s}"] or title_ru
	end

	def alt
		self["alt_#{I18n.locale.to_s}"] or alt_ru
	end
end
