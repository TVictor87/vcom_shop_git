class Currency < ActiveRecord::Base
  def title
    self["title_#{I18n.locale}"] || title_ru
  end

  class << self
    attr_accessor :course
    attr_accessor :currency
    attr_accessor :currency_id
  end
end
