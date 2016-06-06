FactoryGirl.define do
  factory :option do
    options_group_id '1'
    title_ru { Faker::Name.title }
    field_type 'CHECKBOX'
  end
end
