require 'rails_helper'

describe OptionsValue do
  it { should belong_to(:option) }
  it { expect(build(:options_value)).to be_valid }
  it { should validate_presence_of(:option_id) }
  it { should validate_presence_of(:title_ru) }
  it { should validate_length_of(:title_ru).is_at_least(2) }
end
