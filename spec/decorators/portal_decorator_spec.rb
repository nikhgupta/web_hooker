require 'rails_helper'
describe PortalDecorator, type: :decorator do
  let(:portal){ create :portal, title: "PortalX" }
  describe "#title_label" do
    it "generates HTML for producing a label for the portal's title" do
      html = portal.decorate.title_label
      expect(html).to have_selector("span.label.label-info", text: "PortalX")
    end
  end
end
