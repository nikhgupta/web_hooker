require 'rails_helper'

RSpec.describe Account, type: :model do
  it { is_expected.to have_many(:users).dependent(:destroy) }
  it { is_expected.to have_many(:portals).dependent(:destroy) }
  it { is_expected.to have_many(:destinations).dependent(:destroy) }
  it { is_expected.to have_many(:submissions).dependent(:destroy) }
  it { is_expected.to have_many(:replies).dependent(:destroy) }
end
