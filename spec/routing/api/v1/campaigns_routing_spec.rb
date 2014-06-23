require "rails_helper"

RSpec.describe Api::V1::CampaignsController, type: :routing do
  describe "routing" do
    let(:url) { "http://www..lvh.me/api/v1/districts/1/schools/2" }

    it "routes to #index" do
      expect(get: "#{url}/campaigns.json").to route_to("api/v1/campaigns#index", format: 'json', district_id: '1', school_id: '2')
    end

  end
end
