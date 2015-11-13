RSpec.describe RequestForwardingJob, type: :job do
  it "is queued as a high priority job" do
    expect(described_class.queue_name).to eq "high_priority"
  end

  it "enqueues forwarding of submissions to given destinations" do
    assert_enqueued_with(job: RequestForwardingJob, args: [37,73]) do
      described_class.perform_later(37, 73)
    end
  end

  describe "#perform" do
    let(:portal){ create :portal }
    let(:destination){ create :destination, portal: portal }
    let(:submission){
      create :submission, portal: portal, body: "ping", uuid: "SOME-UUID",
      headers: { "Host" => "SomeHost.com", "Key" => "Value" }
    }
    let(:response){ spy(
      "response", code: 200, body: "pong", headers: [["k", ["1", "2"]]],
      content_type: "text/html", content_length: "47"
    )}

    it "forwards the submission to the given destination" do
      expect(HTTParty).to receive(:get).with(destination.url, {
        timeout: 30, body: "ping", headers: {
          "Key" => "Value",
          "X-Webhooker-For" => "SomeHost.com",
          "X-Webhooker-ID" => submission.id.to_s,
          "X-Webhooker-Request-ID" => "SOME-UUID"
        }
      }).and_return response

      stub_env_var :forwarded_request_timeout, 30
      described_class.new.perform submission.id, destination.id
    end

    it "creates a Reply record from the response received" do
      expect(HTTParty).to receive(:get).with(destination.url, any_args()).and_return response
      described_class.new.perform submission.id, destination.id

      reply = Reply.for(submission, destination)
      expect(reply.http_status_code).to eq 200
      expect(reply.content_type).to eq "text/html"
      expect(reply.content_length).to eq 47
      expect(reply.headers).to eq("k" => "1\n2")
      expect(reply.body).to eq "pong"
    end

    it "records the exception raised in the response when creating the reply" do
      expect(HTTParty).to receive(:get).and_raise RuntimeError.new("Some Error")
      described_class.new.perform submission.id, destination.id

      reply = Reply.for(submission, destination)
      body = JSON.parse(reply.body) rescue {}

      expect(reply.http_status_code).to eq 500
      expect(reply.content_type).to eq "application/json"
      expect(reply.content_length).to eq reply.body.length
      expect(reply.headers).to eq({})
      expect(body).not_to be_blank
      expect(body['error']).to eq "RuntimeError: Some Error"
    end
  end
end
