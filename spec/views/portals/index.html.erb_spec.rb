require 'rails_helper'

RSpec.describe "portals/index", type: :view do
  before(:each) do
    assign(:portals, [
      Portal.create!(
        :title => "Title",
        :slug => "Slug",
        :destinations_count => 1
      ),
      Portal.create!(
        :title => "Title",
        :slug => "Slug",
        :destinations_count => 1
      )
    ])
  end

  it "renders a list of portals" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
