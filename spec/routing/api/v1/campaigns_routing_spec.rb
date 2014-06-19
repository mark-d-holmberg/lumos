require "rails_helper"

RSpec.describe Api::V1::CampaignsController, type: :routing do
  describe "routing" do
    let(:url) { "http://api.lvh.me" }

    it "routes to #index" do
      expect(get: "#{url}/v1/campaigns.json").to route_to("api/v1/campaigns#index", format: 'json')
    end

  end
end
