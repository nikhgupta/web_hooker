require "rails_helper"

RSpec.describe PortalsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/portals").to route_to("portals#index")
    end

    it "routes to #new" do
      expect(:get => "/portals/new").to route_to("portals#new")
    end

    it "routes to #show" do
      expect(:get => "/portals/1").to route_to("portals#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/portals/1/edit").to route_to("portals#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/portals").to route_to("portals#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/portals/1").to route_to("portals#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/portals/1").to route_to("portals#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/portals/1").to route_to("portals#destroy", :id => "1")
    end

  end
end
