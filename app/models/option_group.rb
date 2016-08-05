class OptionGroup < ActiveRecord::Base
  include I18nable
  default_scope { order(:priority) }

  has_and_belongs_to_many :categories
  has_many :options
end
