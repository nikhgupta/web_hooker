require 'rails_helper'

RSpec.describe "replies/edit", type: :view do
  before(:each) do
    @reply = assign(:reply, Reply.create!(
      :destination => nil,
      :submission => nil,
      :http_status_code => 1,
      :content_length => 1,
      :content_type => "MyString",
      :headers => "MyText",
      :body => "MyText"
    ))
  end

  it "renders the edit reply form" do
    render

    assert_select "form[action=?][method=?]", reply_path(@reply), "post" do

      assert_select "input#reply_destination_id[name=?]", "reply[destination_id]"

      assert_select "input#reply_submission_id[name=?]", "reply[submission_id]"

      assert_select "input#reply_http_status_code[name=?]", "reply[http_status_code]"

      assert_select "input#reply_content_length[name=?]", "reply[content_length]"

      assert_select "input#reply_content_type[name=?]", "reply[content_type]"

      assert_select "textarea#reply_headers[name=?]", "reply[headers]"

      assert_select "textarea#reply_body[name=?]", "reply[body]"
    end
  end
end
