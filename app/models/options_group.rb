class OptionsGroup < ActiveRecord::Base
  has_many :options, dependent: :destroy

  validates :title_ru, presence: true, length: { minimum: 2 }
  validates :constant_name, presence: true, uniqueness: true
end
