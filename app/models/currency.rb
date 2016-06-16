class Currency < ActiveRecord::Base

	def title
		self["title_#{I18n.locale.to_s}"] or title_ru
	end

end
