require 'rails_helper'

RSpec.describe "destinations/new", type: :view do
  before(:each) do
    assign(:destination, Destination.new(
      :portal => nil,
      :url => "MyString"
    ))
  end

  it "renders new destination form" do
    render

    assert_select "form[action=?][method=?]", destinations_path, "post" do

      assert_select "input#destination_portal_id[name=?]", "destination[portal_id]"

      assert_select "input#destination_url[name=?]", "destination[url]"
    end
  end
end
