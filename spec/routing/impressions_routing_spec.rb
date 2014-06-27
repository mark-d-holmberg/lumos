require "rails_helper"

RSpec.describe ImpressionsController, type: :routing do
  describe "routing" do
    let(:url) { "http://landing.lvh.me/campaigns/12345" }

    it "routes to #create" do
      expect(post: "#{url}/impressions").to route_to("impressions#create", campaign_slug: '12345')
    end

  end
end
