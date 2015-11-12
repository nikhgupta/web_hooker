require 'rails_helper'

RSpec.describe "replies/index", type: :view do
  before(:each) do
    assign(:replies, [
      Reply.create!(
        :destination => nil,
        :submission => nil,
        :http_status_code => 1,
        :content_length => 2,
        :content_type => "Content Type",
        :headers => "MyText",
        :body => "MyText"
      ),
      Reply.create!(
        :destination => nil,
        :submission => nil,
        :http_status_code => 1,
        :content_length => 2,
        :content_type => "Content Type",
        :headers => "MyText",
        :body => "MyText"
      )
    ])
  end

  it "renders a list of replies" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Content Type".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
