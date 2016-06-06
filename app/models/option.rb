class Option < ActiveRecord::Base
  belongs_to :options_group
  has_many :options_values, dependent: :destroy

  validates :title_ru, presence: true, length: { minimum: 2 }
  validates :options_group_id, :field_type, presence: true
end
