class Currency < ActiveRecord::Base
  include I18nable

  class << self
    attr_accessor :course
    attr_accessor :currency
    attr_accessor :currency_id
  end
end
