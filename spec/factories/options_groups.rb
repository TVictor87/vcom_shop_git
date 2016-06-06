FactoryGirl.define do
  factory :options_group do
    title_ru { Faker::Name.title }
    constant_name { Faker::Name.name }
  end
end
