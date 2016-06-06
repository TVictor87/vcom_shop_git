FactoryGirl.define do
  factory :options_value do
    title_ru { Faker::Name.title }
    option_id '1'
  end
end
