require 'rails_helper'

RSpec.describe "destinations/show", type: :view do
  before(:each) do
    @destination = assign(:destination, Destination.create!(
      :portal => nil,
      :url => "Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Url/)
  end
end
