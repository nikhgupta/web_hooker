require 'rails_helper'

RSpec.describe "portals/new", type: :view do
  before(:each) do
    assign(:portal, Portal.new(
      :title => "MyString",
      :slug => "MyString",
      :destinations_count => 1
    ))
  end

  it "renders new portal form" do
    render

    assert_select "form[action=?][method=?]", portals_path, "post" do

      assert_select "input#portal_title[name=?]", "portal[title]"

      assert_select "input#portal_slug[name=?]", "portal[slug]"

      assert_select "input#portal_destinations_count[name=?]", "portal[destinations_count]"
    end
  end
end
