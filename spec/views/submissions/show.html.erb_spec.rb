require 'rails_helper'

RSpec.describe "submissions/show", type: :view do
  before(:each) do
    @submission = assign(:submission, Submission.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Host/)
    expect(rendered).to match(/Ip/)
    expect(rendered).to match(/Uuid/)
    expect(rendered).to match(/Request Method/)
    expect(rendered).to match(/Content Type/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
