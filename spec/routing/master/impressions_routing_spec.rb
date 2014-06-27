require "rails_helper"

RSpec.describe Master::ImpressionsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me/campaigns/12345" }

    it "routes to #index" do
      expect(get: "#{url}/impressions").to route_to("master/impressions#index", campaign_slug: '12345')
    end

    it "routes to #new" do
      expect(get: "#{url}/impressions/new").to route_to("master/impressions#new", campaign_slug: '12345')
    end

    it "routes to #show" do
      expect(get: "#{url}/impressions/1").to route_to("master/impressions#show", id: "1", campaign_slug: '12345')
    end

    it "routes to #edit" do
      expect(get: "#{url}/impressions/1/edit").to route_to("master/impressions#edit", id: "1", campaign_slug: '12345')
    end

    it "routes to #create" do
      expect(post: "#{url}/impressions").to route_to("master/impressions#create", campaign_slug: '12345')
    end

    it "routes to #update" do
      expect(put: "#{url}/impressions/1").to route_to("master/impressions#update", id: "1", campaign_slug: '12345')
    end

    it "routes to #destroy" do
      expect(delete: "#{url}/impressions/1").to route_to("master/impressions#destroy", id: "1", campaign_slug: '12345')
    end

  end
end
