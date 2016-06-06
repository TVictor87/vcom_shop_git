require 'rails_helper'

describe OptionsGroup do
  it { should have_many(:options) }
  it { expect(build(:options_group)).to be_valid }
  it { should validate_presence_of(:title_ru) }
  it { should validate_length_of(:title_ru).is_at_least(2) }
  it { should validate_presence_of(:constant_name) }
  it { should validate_uniqueness_of(:constant_name) }
end
