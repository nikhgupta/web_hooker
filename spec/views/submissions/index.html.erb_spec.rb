require 'rails_helper'

RSpec.describe "submissions/index", type: :view do
  before(:each) do
    assign(:submissions, [
      Submission.create!(
        :portal => nil,
        :host => "Host",
        :ip => "Ip",
        :uuid => "Uuid",
        :request_method => "Request Method",
        :content_type => "Content Type",
        :content_length => 1,
        :headers => "MyText",
        :body => "MyText",
        :successful_replies_count => 2,
        :failed_replies_count => 3
      ),
      Submission.create!(
        :portal => nil,
        :host => "Host",
        :ip => "Ip",
        :uuid => "Uuid",
        :request_method => "Request Method",
        :content_type => "Content Type",
        :content_length => 1,
        :headers => "MyText",
        :body => "MyText",
        :successful_replies_count => 2,
        :failed_replies_count => 3
      )
    ])
  end

  it "renders a list of submissions" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Host".to_s, :count => 2
    assert_select "tr>td", :text => "Ip".to_s, :count => 2
    assert_select "tr>td", :text => "Uuid".to_s, :count => 2
    assert_select "tr>td", :text => "Request Method".to_s, :count => 2
    assert_select "tr>td", :text => "Content Type".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
