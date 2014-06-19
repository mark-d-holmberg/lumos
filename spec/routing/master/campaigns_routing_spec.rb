require "rails_helper"

RSpec.describe Master::CampaignsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #index" do
      expect(get: "#{url}/campaigns").to route_to("master/campaigns#index")
    end

    it "routes to #new" do
      expect(get: "#{url}/campaigns/new").to route_to("master/campaigns#new")
    end

    it "routes to #show" do
      expect(get: "#{url}/campaigns/1").to route_to("master/campaigns#show", slug: "1")
    end

    it "routes to #edit" do
      expect(get: "#{url}/campaigns/1/edit").to route_to("master/campaigns#edit", slug: "1")
    end

    it "routes to #create" do
      expect(post: "#{url}/campaigns").to route_to("master/campaigns#create")
    end

    it "routes to #update" do
      expect(put: "#{url}/campaigns/1").to route_to("master/campaigns#update", slug: "1")
    end

    it "routes to #destroy" do
      expect(delete: "#{url}/campaigns/1").to route_to("master/campaigns#destroy", slug: "1")
    end

  end
end
