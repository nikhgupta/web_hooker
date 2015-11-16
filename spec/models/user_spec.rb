require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to belong_to(:account).counter_cache }
  it { is_expected.to validate_presence_of(:account_id) }
end
