class OptionsValue < ActiveRecord::Base
  belongs_to :option

  validates :title_ru, presence: true, length: { minimum: 2 }
  validates :option_id, presence: true
end
