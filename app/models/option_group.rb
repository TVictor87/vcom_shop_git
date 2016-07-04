class OptionGroup < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :options

  def title
    self["title_#{I18n.locale}"] || title_ru
  end
end
