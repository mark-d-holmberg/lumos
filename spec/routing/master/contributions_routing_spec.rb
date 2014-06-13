require "rails_helper"

RSpec.describe Master::ContributionsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #index" do
      expect(get: "#{url}/contributions").to route_to("master/contributions#index")
    end

    it "routes to #new" do
      expect(get: "#{url}/contributions/new").to route_to("master/contributions#new")
    end

    it "routes to #show" do
      expect(get: "#{url}/contributions/1").to route_to("master/contributions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "#{url}/contributions/1/edit").to route_to("master/contributions#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "#{url}/contributions").to route_to("master/contributions#create")
    end

    it "routes to #update" do
      expect(put: "#{url}/contributions/1").to route_to("master/contributions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "#{url}/contributions/1").to route_to("master/contributions#destroy", id: "1")
    end

  end
end
