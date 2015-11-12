require 'rails_helper'

RSpec.describe "replies/show", type: :view do
  before(:each) do
    @reply = assign(:reply, Reply.create!(
      :destination => nil,
      :submission => nil,
      :http_status_code => 1,
      :content_length => 2,
      :content_type => "Content Type",
      :headers => "MyText",
      :body => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Content Type/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
