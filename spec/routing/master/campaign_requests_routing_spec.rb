require "rails_helper"

RSpec.describe Master::CampaignRequestsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #index" do
      expect(get: "#{url}/campaign_requests").to route_to("master/campaign_requests#index")
    end

    it "routes to #show" do
      expect(get: "#{url}/campaign_requests/abc123").to route_to("master/campaign_requests#show", slug: "abc123")
    end

    it "routes to #edit" do
      expect(get: "#{url}/campaign_requests/abc123/edit").to route_to("master/campaign_requests#edit", slug: "abc123")
    end

    it "routes to #update" do
      expect(put: "#{url}/campaign_requests/abc123").to route_to("master/campaign_requests#update", slug: "abc123")
    end

    it "routes to #destroy" do
      expect(delete: "#{url}/campaign_requests/abc123").to route_to("master/campaign_requests#destroy", slug: "abc123")
    end

    it "routes to #convert via GET" do
      expect(get: "#{url}/campaign_requests/abc123/convert").to route_to("master/campaign_requests#convert", slug: "abc123")
    end

    it "routes to #convert via POST" do
      expect(post: "#{url}/campaign_requests/abc123/convert").to route_to("master/campaign_requests#convert", slug: "abc123")
    end

  end
end
