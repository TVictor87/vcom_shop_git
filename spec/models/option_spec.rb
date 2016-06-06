require 'rails_helper'

describe Option do
  it { should belong_to(:options_group) }
  it { should have_many(:options_values) }
  it { expect(build(:option)).to be_valid }
  it { should validate_presence_of(:options_group_id) }
  it { should validate_presence_of(:title_ru) }
  it { should validate_length_of(:title_ru).is_at_least(2) }
  it { should validate_presence_of(:field_type) }
end
