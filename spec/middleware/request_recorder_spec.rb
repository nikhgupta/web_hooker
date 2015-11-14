RSpec.describe RequestRecorder do
  let(:app){ ->(env){[200, env, ["OK"]]} }
  subject{ described_class.new(app, path_prefix: /\/path\/to\//) }
  let(:portal){ create :portal}

  def mock_env_for(options = {})
    stubs = options.delete(:stub) || {}
    env = Rack::MockRequest.env_for("/path/to/#{portal.slug}", options)
    env.merge(stubs)
  end

  it "creates a submission entry from the matching incoming request" do
    code, env = nil, mock_env_for(input: "ping=pong")
    expect{ code, env = subject.call(env) }.to change { Submission.count }.by 1
    expect(env['HTTP_X_WEBHOOKER_SUBMISSION_ID']).to be_present

    submission = Submission.find env['HTTP_X_WEBHOOKER_SUBMISSION_ID']
    expect(submission).to be_present.and be_persisted
    expect(submission.portal).to eq portal
  end

  it "does not create a submission entry from unmatched incoming request" do
    code, env = nil, Rack::MockRequest.env_for("/wrong/#{portal.slug}")
    expect{ code, env = subject.call(env) }.not_to change{ Submission.count }
    expect(env['HTTP_X_WEBHOOKER_SUBMISSION_ID']).to be_nil

    code, env = nil, Rack::MockRequest.env_for("/path/to/no-such-portal-uuid")
    expect{ code, env = subject.call(env) }.not_to change{ Submission.count }
    expect(env['HTTP_X_WEBHOOKER_SUBMISSION_ID']).to be_nil
  end

  it "sets http headers to identify that the request was WebHookered" do
    code, env = subject.call mock_env_for(stub: {"HTTP_HOST" => "SomeHost.com"})
    expect(env['HTTP_X_WEBHOOKER_SUBMISSION_ID']).to be_present
    expect(env['HTTP_X_WEBHOOKER_FOR']).to eq "SomeHost.com"
  end

  it "extracts relevant data from the incoming request into a Submission" do
    code, env = subject.call mock_env_for(input: "ping=pong", stub: {
      "HTTP_HOST" => "SomeHost.com",
      "action_dispatch.request_id" => "SOME-UUID",
      "HTTP_X_FORWARDED_FOR" => "123.123.123.123",
      "CONTENT_LENGTH" => "20",
      "CONTENT_TYPE" => "application/json",
      "SERVER_RANDOM" => "random"
    })

    submission = Submission.find env['HTTP_X_WEBHOOKER_SUBMISSION_ID']

    expect(submission.body).to eq "ping=pong"
    expect(submission.content_type).to eq "application/json"
    expect(submission.content_length).to eq 20
    expect(submission.uuid).to eq "SOME-UUID"
    expect(submission.host).to eq "SomeHost.com"
    expect(submission.ip).to eq "123.123.123.123"
    expect(submission.headers).to eq({
      "Host" => "SomeHost.com",
      "X-Forwarded-For" => "123.123.123.123",
      "Content-Length" => "20",
      "Content-Type" => "application/json"
    })
  end
end
