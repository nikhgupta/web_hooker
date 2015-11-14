RSpec.describe "Portals", type: :request do
  describe "GET /portals" do
    it "requires authentication" do
      get portals_path
      expect(response).to have_http_status(302)
      expect(response).to be_redirect
    end

    it "does not redirect if user is logged in" do
      login_as create(:confirmed_user)
      get portals_path
      expect(response).to have_http_status(200)
      expect(response).not_to be_redirect
    end
  end

  describe "Portal Router" do
    let(:portal){ create :portal }
    let(:url){ portal_router_path(portal) }
    let(:headers) { Hash[
      "Host" => "SomeHost.com", "Content-Type" => "text/html",
      "X-Forwarded-For" => "123.123.123.123", "Test-Key" => "Test-Value",
      "Content-Length" => "10", "Accept" => "*/*"
    ]}

    context "GET requests" do
      it "does not require authentication" do
        get url
        expect(response).to have_http_status 202
        expect(response.body).to be_blank
      end

      it "creates a submission for the incoming request" do
        expect{ get url }.to change{ Submission.count }.by 1
        expect(Submission.last.host).to eq "www.example.com"
      end

      it "saves all headers for the incoming request" do
        expect{ get url, {}, headers }.to change{ Submission.count }.by 1
        expect(Submission.last.headers).to match hash_including(
          "Accept" => "*/*", "Test-Key" => "Test-Value",
          "Host" => "SomeHost.com", "Content-Length" => "10",
          "X-Forwarded-For" => "123.123.123.123"
        )
      end

      it "populates submission fields from the incoming request" do
        expect{ get url, {}, headers }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.ip).to eq "123.123.123.123"
        expect(submission.host).to eq "SomeHost.com"
        expect(submission.uuid).to match /^.{8}-.{4}-.{4}-.{4}-.{12}$/
        expect(submission.content_type).to eq "text/html"
        expect(submission.content_length).to eq 10
        expect(submission.request_method).to eq "get"
      end

      it "saves query params and body in submission's payload as a Hash" do
        expect{ get "#{url}?a&b=&c=1", ping: :pong }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.body).to be_blank # should always be for GET requests
        expect(submission.payload).to eq("a" => nil, "b" => "", "c" => "1", "ping" => "pong")

        raw_body = SecureRandom.uuid
        expect{ get "#{url}?a&b=&c=1", raw_body }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.body).to be_blank
        expect(submission.payload).to eq("a" => nil, "b" => "", "c" => "1", raw_body => nil)
      end
    end

    context "POST requests" do
      it "does not require authentication" do
        post url
        expect(response).to have_http_status 202
        expect(response.body).to be_blank
      end

      it "creates a submission for the incoming request" do
        expect{ post url }.to change{ Submission.count }.by 1
        expect(Submission.last.host).to eq "www.example.com"
      end

      it "saves all headers for the incoming request" do
        expect{ post url, {}, headers }.to change{ Submission.count }.by 1
        expect(Submission.last.headers).to match hash_including(
          "Accept" => "*/*", "Test-Key" => "Test-Value",
          "Host" => "SomeHost.com", "Content-Length" => "10",
          "X-Forwarded-For" => "123.123.123.123"
        )
      end

      it "populates submission fields from the incoming request" do
        expect{ post url, {}, headers }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.ip).to eq "123.123.123.123"
        expect(submission.host).to eq "SomeHost.com"
        expect(submission.body).to be_blank
        expect(submission.uuid).to match /^.{8}-.{4}-.{4}-.{4}-.{12}$/
        expect(submission.content_type).to eq "text/html"
        expect(submission.content_length).to eq 10
        expect(submission.request_method).to eq "post"
      end

      it "saves query params and raw body in submission's payload and body respectively" do
        expect{ post "#{url}?ping=pong", tik: :tok }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.body).to eq "tik=tok"
        expect(submission.payload).to eq("ping" => "pong")

        raw_body = SecureRandom.uuid
        expect{ post "#{url}?a&b=&c=1", raw_body }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.body).to eq raw_body
        expect(submission.payload).to eq("a" => nil, "b" => "", "c" => "1")
      end
    end

    context "PUT requests" do
      it "does not require authentication" do
        put url
        expect(response).to have_http_status 202
        expect(response.body).to be_blank
      end

      it "creates a submission for the incoming request" do
        expect{ put url }.to change{ Submission.count }.by 1
        expect(Submission.last.host).to eq "www.example.com"
      end

      it "saves all headers for the incoming request" do
        expect{ put url, {}, headers }.to change{ Submission.count }.by 1
        expect(Submission.last.headers).to match hash_including(
          "Accept" => "*/*", "Test-Key" => "Test-Value",
          "Host" => "SomeHost.com", "Content-Length" => "10",
          "X-Forwarded-For" => "123.123.123.123"
        )
      end

      it "populates submission fields from the incoming request" do
        put url, {}, headers
        submission = Submission.last
        expect(submission.ip).to eq "123.123.123.123"
        expect(submission.host).to eq "SomeHost.com"
        expect(submission.body).to be_blank
        expect(submission.uuid).to match /^.{8}-.{4}-.{4}-.{4}-.{12}$/
        expect(submission.content_type).to eq "text/html"
        expect(submission.content_length).to eq 10
        expect(submission.request_method).to eq "put"
      end

      it "saves query params and raw body in submission's payload and body respectively" do
        expect{ put "#{url}?ping=pong", tik: :tok }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.body).to eq "tik=tok"
        expect(submission.payload).to eq("ping" => "pong")

        raw_body = SecureRandom.uuid
        expect{ put "#{url}?a&b=&c=1", raw_body }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.body).to eq raw_body
        expect(submission.payload).to eq("a" => nil, "b" => "", "c" => "1")
      end
    end

    context "PATCH requests" do
      it "does not require authentication" do
        patch url
        expect(response).to have_http_status 202
        expect(response.body).to be_blank
      end

      it "creates a submission for the incoming request" do
        expect{ patch url }.to change{ Submission.count }.by 1
        expect(Submission.last.host).to eq "www.example.com"
      end

      it "saves all headers for the incoming request" do
        expect{ patch url, {}, headers }.to change{ Submission.count }.by 1
        expect(Submission.last.headers).to match hash_including(
          "Accept" => "*/*", "Test-Key" => "Test-Value",
          "Host" => "SomeHost.com", "Content-Length" => "10",
          "X-Forwarded-For" => "123.123.123.123"
        )
      end

      it "populates submission fields from the incoming request" do
        patch url, {}, headers
        submission = Submission.last
        expect(submission.ip).to eq "123.123.123.123"
        expect(submission.host).to eq "SomeHost.com"
        expect(submission.body).to be_blank
        expect(submission.uuid).to match /^.{8}-.{4}-.{4}-.{4}-.{12}$/
        expect(submission.content_type).to eq "text/html"
        expect(submission.content_length).to eq 10
        expect(submission.request_method).to eq "patch"
      end

      it "saves query params and raw body in submission's payload and body respectively" do
        expect{ patch "#{url}?ping=pong", tik: :tok }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.body).to eq "tik=tok"
        expect(submission.payload).to eq("ping" => "pong")

        raw_body = SecureRandom.uuid
        expect{ patch "#{url}?a&b=&c=1", raw_body }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.body).to eq raw_body
        expect(submission.payload).to eq("a" => nil, "b" => "", "c" => "1")
      end
    end

    context "DELETE requests" do
      it "does not require authentication" do
        delete url
        expect(response).to have_http_status 202
        expect(response.body).to be_blank
      end

      it "creates a submission for the incoming request" do
        expect{ delete url }.to change{ Submission.count }.by 1
        expect(Submission.last.host).to eq "www.example.com"
      end

      it "saves all headers for the incoming request" do
        expect{ delete url, {}, headers }.to change{ Submission.count }.by 1
        expect(Submission.last.headers).to match hash_including(
          "Accept" => "*/*", "Test-Key" => "Test-Value",
          "Host" => "SomeHost.com", "Content-Length" => "10",
          "X-Forwarded-For" => "123.123.123.123"
        )
      end

      it "populates submission fields from the incoming request" do
        delete url, {}, headers
        submission = Submission.last
        expect(submission.ip).to eq "123.123.123.123"
        expect(submission.host).to eq "SomeHost.com"
        expect(submission.body).to be_blank
        expect(submission.uuid).to match /^.{8}-.{4}-.{4}-.{4}-.{12}$/
        expect(submission.content_type).to eq "text/html"
        expect(submission.content_length).to eq 10
        expect(submission.request_method).to eq "delete"
      end

      it "saves query params and raw body in submission's payload and body respectively" do
        expect{ delete "#{url}?ping=pong", tik: :tok }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.body).to eq "tik=tok"
        expect(submission.payload).to eq("ping" => "pong")

        raw_body = SecureRandom.uuid
        expect{ delete "#{url}?a&b=&c=1", raw_body }.to change{ Submission.count }.by 1
        submission = Submission.last
        expect(submission.body).to eq raw_body
        expect(submission.payload).to eq("a" => nil, "b" => "", "c" => "1")
      end
    end
  end
end
