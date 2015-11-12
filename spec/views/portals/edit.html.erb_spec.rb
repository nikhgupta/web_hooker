require 'rails_helper'

RSpec.describe "portals/edit", type: :view do
  before(:each) do
    @portal = assign(:portal, Portal.create!(
      :title => "MyString",
      :slug => "MyString",
      :destinations_count => 1
    ))
  end

  it "renders the edit portal form" do
    render

    assert_select "form[action=?][method=?]", portal_path(@portal), "post" do

      assert_select "input#portal_title[name=?]", "portal[title]"

      assert_select "input#portal_slug[name=?]", "portal[slug]"

      assert_select "input#portal_destinations_count[name=?]", "portal[destinations_count]"
    end
  end
end
