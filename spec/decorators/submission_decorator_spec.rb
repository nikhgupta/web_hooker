require 'rails_helper'

describe SubmissionDecorator, type: :decorator do
  let(:portal) { create :portal, title: "Some Portal" }
  let(:submission){
    create(
      :submission, portal: portal, with_destinations: 5,
      with_failed_replies: 2, with_successful_replies: 2,
      uuid: "abcdefgh", request_method: "get",
      headers: {
        "Key" => "Value", "Accept" => "application/json",
        "Host" => "SomeHost.com", "Version" => "HTTP v1.1"
      }
    )
  }

  def decorated; submission.reload.decorate; end

  it "decorates associated portal" do
    expect(decorated.portal).to be_a PortalDecorator
  end

  it "decorates uuid" do
    expect(decorated.uuid).to eq "<code>abcdefgh</code>"
  end

  it "decorates status" do
    expect(decorated.status).to eq "Pending"
  end

  it "decorates request_method" do
    expect(decorated.request_method).to eq "GET"
  end

  it "decorates accept header" do
    expect(decorated.accept_type).to eq "application/json"
  end

  it "decorates received_at timestamp" do
    travel_to Time.new(2000, 01, 01, 01, 01, 01, "+00:00")
    expect_any_instance_of(SubmissionDecorator).to receive(:timestamp_for).with(:created_at)
    html = decorated.received_at
    expect(html).to include "Saturday, January 01, 2000 01:01 UTC"
  end

  it "decorates the link for the portal" do
    html = decorated.portal_link
    expect(html).to have_link "Some Portal"
  end

  describe "#size" do
    it "returns the size of request in human-understandable format" do
      map = [
        [1, "1 byte"], [2, "2 bytes"], [100, "100 bytes"],
        [1000, "0.98KB"], [400_000, "0.38MB"], [2.35*10**8, "0.22GB"],
        [10**9, "0.93GB"], [10**10, "9.31GB"], [10**11, "93.13GB"],
        [10**12, "wtf!"]
      ].each do |pair|
        allow(submission).to receive(:content_length).and_return pair[0]
        expect(decorated.size).to eq pair[1]
      end
    end
  end

  describe "#status_style" do
    it "default style for the submission based on its status" do
      expect(decorated.status_style).to eq :default

      create :reply, submission: submission
      expect(decorated.status_style).to eq :warning

      submission.replies.destroy_all
      submission.destinations.count.times { create :reply, submission: submission, http_status_code: 200 }
      expect(decorated.status_style).to eq :success

      submission.replies.destroy_all
      submission.destinations.count.times { create :reply, submission: submission, http_status_code: 400 }
      expect(decorated.status_style).to eq :danger
    end
  end

  describe "#ping_balls" do
    let(:html){ decorated.ping_balls }

    it "has green ping balls for pending replies" do
      expect(html).to have_selector("span.ping-ball.successful", count: 2)
    end
    it "has red ping balls for pending replies" do
      expect(html).to have_selector("span.ping-ball.failed", count: 2)
    end
    it "has grey ping balls for pending replies" do
      expect(html).to have_selector("span.ping-ball.pending", count: 1)
    end
  end
end
