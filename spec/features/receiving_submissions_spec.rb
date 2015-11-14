# NOTE: Most of the relevant specs have been covered in
# `spec/requests/portals_spec`. Specs here are on a broader scale and very
# minimal to only test functionality which could not be tested in request specs.
#
RSpec.feature "Receiving Submissions", type: :feature, js: true do

  # Simulate a CLI client sending CURL requests, and only interested in the
  # headers received.
  def curl_request_headers(method, url)
    command  = []
    command << `which curl`.strip
    command << "-X #{method.to_s.parameterize.upcase}"
    command << "-d '{\"ping\":\"pong\"}'"
    command << "-H 'Accept: application/json'"
    command << "-H 'Content-Type: application/json'"
    command << "-D - \"#{url}\" --silent"
    %x(#{command.join(" ")}).split("\r\n\r\n")
  end

  let(:portal){ create :portal }
  let(:server){ "#{Capybara.server_host}:#{Capybara.server_port}"}
  let(:url){ "http://#{server}#{portal_router_path(portal)}"}
  before(:each){ visit root_path } # PhantomJS server wont run without this

  scenario "responds with 202 Accepted on receiving submissions for recognized HTTP Verbs" do
    # NOTE: There is a bug in Rails v4.2.5 where CONNECT gives 500 error
    http_methods = ActionDispatch::Request::HTTP_METHODS - ["CONNECT"]

    http_methods.each do |http_method|
      headers, body = curl_request_headers(http_method, url)
      expect(headers).to include("HTTP/1.1 202 Accepted"),
        "Expected #{http_method} to return 202 Accepted"
      expect(body).to be_blank
    end
  end
  scenario "responds with 405 Method Not Allowed on receiving submissions for unrecognized HTTP Verbs" do
    headers, body = curl_request_headers("WHATEVER", url)
    expect(headers).to include("HTTP/1.1 405 Method Not Allowed")
    expect(body).to be_blank
  end

  scenario "responds with 200 Accepted for CONNECT Verb" do
    pending "[BUG] Rails v4.2.5 has a bug that returns 500 for Connect Verb instead of 200"
    headers, body = curl_request_headers("CONNECT", url)
    expect(headers).to include("HTTP/1.1 200 Accepted")
    expect(body).to be_blank
  end
end
