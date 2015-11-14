require 'rails_helper'

RSpec.describe Portal, type: :model do
  it { is_expected.to belong_to(:user).counter_cache }
  it { is_expected.to have_many(:submissions).dependent(:destroy) }
  it { is_expected.to have_many(:destinations).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:title) }
  # it { is_expected.to validate_presence_of(:slug) }
  # it { is_expected.to validate_uniqueness_of(:slug) }

  it "generates a random 48-char slug for the portal on creation" do
    portal = create :portal
    expect(portal).to be_valid.and be_persisted
    expect(portal.reload.slug).to be_present
    expect(portal.slug.length).to eq 48
  end

  it "does not change the generated slug on updating" do
    portal = create :portal
    old_slug = portal.slug
    portal.update_attribute :title, "New Title"
    expect(old_slug).to eq portal.reload.slug
  end
end
