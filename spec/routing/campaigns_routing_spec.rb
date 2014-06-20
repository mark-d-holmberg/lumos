require "rails_helper"

RSpec.describe CampaignsController, type: :routing do
  describe "routing" do
    let(:url) { "http://landing.lvh.me" }

    it "routes to #show" do
      expect(get: "#{url}/campaigns/12345abc").to route_to("campaigns#show", slug: "12345abc")
    end

  end
end
