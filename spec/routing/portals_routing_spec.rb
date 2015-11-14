require "rails_helper"

RSpec.describe PortalsController, type: :routing do
  include_context "routing specs - stubbed devise authentication - verify rest routes"

  context "custom routing" do
    let(:portal) { create :portal }
    let(:path) { "/for/#{portal.to_param}"}

    context "with authenticated user" do
      let(:authenticated?) { true }
      it "routes all known HTTP methods to #route from /for/:portal" do
        routes_all_known_http_methods_to? "portals#route", id: portal.slug
      end
    end
    context "with unauthenticated user" do
      let(:authenticated?) { false }
      it "routes all known HTTP methods to #route from /for/:portal" do
        routes_all_known_http_methods_to? "portals#route", id: portal.slug
      end
    end
  end
end
