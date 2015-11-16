require 'rails_helper'

RSpec.describe Destination, type: :model do
  it { is_expected.to belong_to(:account).counter_cache }
  it { is_expected.to validate_presence_of(:account_id) }
  it { is_expected.to belong_to(:portal).counter_cache }
  it { is_expected.to have_many(:replies).dependent(:nullify) }
  it { is_expected.to have_many(:submissions).through(:replies) }
  it { is_expected.to validate_presence_of(:url) }
end
