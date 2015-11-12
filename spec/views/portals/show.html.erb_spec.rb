require 'rails_helper'

RSpec.describe "portals/show", type: :view do
  before(:each) do
    @portal = assign(:portal, Portal.create!(
      :title => "Title",
      :slug => "Slug",
      :destinations_count => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/1/)
  end
end
