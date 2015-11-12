require 'rails_helper'

RSpec.describe "submissions/new", type: :view do
  before(:each) do
    assign(:submission, Submission.new(
      :portal => nil,
      :host => "MyString",
      :ip => "MyString",
      :uuid => "MyString",
      :request_method => "MyString",
      :content_type => "MyString",
      :content_length => 1,
      :headers => "MyText",
      :body => "MyText",
      :successful_replies_count => 1,
      :failed_replies_count => 1
    ))
  end

  it "renders new submission form" do
    render

    assert_select "form[action=?][method=?]", submissions_path, "post" do

      assert_select "input#submission_portal_id[name=?]", "submission[portal_id]"

      assert_select "input#submission_host[name=?]", "submission[host]"

      assert_select "input#submission_ip[name=?]", "submission[ip]"

      assert_select "input#submission_uuid[name=?]", "submission[uuid]"

      assert_select "input#submission_request_method[name=?]", "submission[request_method]"

      assert_select "input#submission_content_type[name=?]", "submission[content_type]"

      assert_select "input#submission_content_length[name=?]", "submission[content_length]"

      assert_select "textarea#submission_headers[name=?]", "submission[headers]"

      assert_select "textarea#submission_body[name=?]", "submission[body]"

      assert_select "input#submission_successful_replies_count[name=?]", "submission[successful_replies_count]"

      assert_select "input#submission_failed_replies_count[name=?]", "submission[failed_replies_count]"
    end
  end
end
