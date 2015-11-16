require 'rails_helper'

RSpec.describe Reply, type: :model do
  let(:failed)     { create :reply, http_status_code: 403 }
  let(:successful) { create :reply, http_status_code: 202 }
  let(:unknown)    { create :reply, http_status_code: nil }
  let(:new_record) { build  :reply }

  it { is_expected.to belong_to(:account).counter_cache }
  it { is_expected.to validate_presence_of(:account_id) }
  it { is_expected.to belong_to :submission }
  it { is_expected.to belong_to :destination }

  it "has scope for finding all failed and successful replies" do
    expect(described_class.failed).to include failed
    expect(described_class.failed).not_to include successful
    expect(described_class.failed).not_to include unknown

    expect(described_class.successful).to include successful
    expect(described_class.successful).not_to include failed
    expect(described_class.successful).not_to include unknown
  end

  it "has methods to retrieve status of the reply" do
    expect(failed).to     be_failed
    expect(unknown).to    be_pending
    expect(new_record).to be_pending
    expect(successful).to be_successful

    expect(failed.status).to     eq :failed
    expect(unknown.status).to    eq :pending
    expect(new_record.status).to eq :pending
    expect(successful.status).to eq :successful
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
