require 'rails_helper'

RSpec.describe Submission, type: :model do
  it { is_expected.to belong_to(:portal).counter_cache }
  it { is_expected.to have_many(:replies).dependent(:destroy) }
  it { is_expected.to have_many(:destinations).through(:portal) }
  # it { is_expected.to validate_presence_of(:host) }
  it { is_expected.to validate_presence_of(:uuid) }
  it { is_expected.to validate_uniqueness_of(:uuid) }
  it { is_expected.to validate_presence_of(:request_method) }

  it "keeps a count of pending replies and failed/successful replies received" do
    submission = create :submission, with_destinations: 3
    destinations = submission.destinations

    create :reply, submission: submission, destination: destinations[0], http_status_code: 400
    expect(submission.reload.status).to eq :pending
    expect(submission.pending_replies_count).to eq 2

    create :reply, submission: submission, destination: destinations[1], http_status_code: 301
    create :reply, submission: submission, destination: destinations[2], http_status_code: 301
    submission.replies.last.update_attribute :body, "something"
    submission.reload
    expect(submission.status).to eq :partially_successful
    expect(submission.pending_replies_count).to eq 0
    expect(submission.failed_replies_count).to eq 1
    expect(submission.successful_replies_count).to eq 2

    submission.replies.first.destroy
    create :reply, submission: submission, destination: destinations[0], http_status_code: 200
    submission.reload
    expect(submission.failed_replies_count).to eq 0
    expect(submission.successful_replies_count).to eq 3
    expect(submission.status).to eq :successful

    submission.replies.destroy_all
    create :reply, submission: submission, destination: destinations[0], http_status_code: 400
    create :reply, submission: submission, destination: destinations[1], http_status_code: 401
    create :reply, submission: submission, destination: destinations[2], http_status_code: 501
    submission.reload
    expect(submission.failed_replies_count).to eq 3
    expect(submission.successful_replies_count).to eq 0
    expect(submission.status).to eq :failed
  end

  describe "#replies_including_awaited" do
    it "lists all replies that have been received or are pending" do
      submission = create :submission, with_destinations: 3, with_successful_replies: 1
      expect(Reply).to receive(:for).exactly(3).times.and_call_original
      replies = submission.replies_including_awaited
      expect(replies).to include(*submission.replies)
      expect(replies.count).to eq 3
      expect(replies.count(&:persisted?)).to  eq 1
      expect(replies.count(&:new_record?)).to eq 2
    end
  end
end
