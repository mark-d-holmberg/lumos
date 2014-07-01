require "rails_helper"

RSpec.describe Master::SchoolsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me/districts/1940" }

    it "routes to #index" do
      expect(get: "#{url}/schools").to route_to("master/schools#index", district_id: "1940")
    end

    it "routes to #new" do
      expect(get: "#{url}/schools/new").to route_to("master/schools#new", district_id: "1940")
    end

    it "routes to #show" do
      expect(get: "#{url}/schools/1").to route_to("master/schools#show", id: "1", district_id: "1940")
    end

    it "routes to #edit" do
      expect(get: "#{url}/schools/1/edit").to route_to("master/schools#edit", id: "1", district_id: "1940")
    end

    it "routes to #create" do
      expect(post: "#{url}/schools").to route_to("master/schools#create", district_id: "1940")
    end

    it "routes to #update" do
      expect(put: "#{url}/schools/1").to route_to("master/schools#update", id: "1", district_id: "1940")
    end

    it "routes to #destroy" do
      expect(delete: "#{url}/schools/1").to route_to("master/schools#destroy", id: "1", district_id: "1940")
    end

  end
end
