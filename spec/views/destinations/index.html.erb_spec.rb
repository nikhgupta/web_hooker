require 'rails_helper'

RSpec.describe "destinations/index", type: :view do
  before(:each) do
    assign(:destinations, [
      Destination.create!(
        :portal => nil,
        :url => "Url"
      ),
      Destination.create!(
        :portal => nil,
        :url => "Url"
      )
    ])
  end

  it "renders a list of destinations" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
  end
end
