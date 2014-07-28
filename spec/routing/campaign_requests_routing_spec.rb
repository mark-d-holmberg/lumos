require "rails_helper"

RSpec.describe CampaignRequestsController, type: :routing do
  describe "routing" do
    let(:url) { "http://landing.lvh.me" }

    it "routes to #new" do
      expect(get: "#{url}/campaign_requests/new").to route_to("campaign_requests#new")
    end

    it "routes to #show" do
      expect(get: "#{url}/campaign_requests/abc123").to route_to("campaign_requests#show", slug: "abc123")
    end

    it "routes to #create" do
      expect(post: "#{url}/campaign_requests").to route_to("campaign_requests#create")
    end

  end
end
