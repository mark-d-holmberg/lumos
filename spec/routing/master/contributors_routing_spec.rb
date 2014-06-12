require "rails_helper"

RSpec.describe Master::ContributorsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #index" do
      expect(get: "#{url}/contributors").to route_to("master/contributors#index")
    end

    it "routes to #new" do
      expect(get: "#{url}/contributors/new").to route_to("master/contributors#new")
    end

    it "routes to #show" do
      expect(get: "#{url}/contributors/1").to route_to("master/contributors#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "#{url}/contributors/1/edit").to route_to("master/contributors#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "#{url}/contributors").to route_to("master/contributors#create")
    end

    it "routes to #update" do
      expect(put: "#{url}/contributors/1").to route_to("master/contributors#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "#{url}/contributors/1").to route_to("master/contributors#destroy", id: "1")
    end

  end
end
