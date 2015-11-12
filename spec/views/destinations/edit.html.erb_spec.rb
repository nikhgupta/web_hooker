require 'rails_helper'

RSpec.describe "destinations/edit", type: :view do
  before(:each) do
    @destination = assign(:destination, Destination.create!(
      :portal => nil,
      :url => "MyString"
    ))
  end

  it "renders the edit destination form" do
    render

    assert_select "form[action=?][method=?]", destination_path(@destination), "post" do

      assert_select "input#destination_portal_id[name=?]", "destination[portal_id]"

      assert_select "input#destination_url[name=?]", "destination[url]"
    end
  end
end
