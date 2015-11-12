require 'rails_helper'

RSpec.describe Reply, type: :model do
  it { is_expected.to belong_to :submission }
  it { is_expected.to belong_to :destination }

  it "has scope for finding all failed and successful replies" do
    failed = create(:reply, http_status_code: 403)
    successful = create(:reply, http_status_code: 202)

    expect(described_class.successful).to include successful
    expect(described_class.successful).not_to include failed
    expect(described_class.failed).to include failed
    expect(described_class.failed).not_to include successful
  end

  describe ".http_status_message" do
    it "returns HTTP Status for the given HTTP status code" do
      reply = build_stubbed(:reply, http_status_code: 200)
      expect(reply.http_status_message).to eq "OK"

      reply = build_stubbed(:reply, http_status_code: 503)
      expect(reply.http_status_message).to eq "Service Unavailable"
    end
  end
end
