require "rails_helper"

RSpec.describe CampaignsController, type: :routing do
  describe "routing" do
    let(:url) { "http://landing.lvh.me" }

    it "routes to #new" do
      expect(get: "#{url}/campaigns/new").to route_to("campaigns#new")
    end

    it "routes to #create" do
      expect(post: "#{url}/campaigns").to route_to("campaigns#create")
    end

    it "routes to #show" do
      expect(get: "#{url}/campaigns/12345abc").to route_to("campaigns#show", slug: "12345abc")
    end

    it "routes to #reports" do
      expect(get: "#{url}/campaigns/12345abc/reports").to route_to("campaigns#reports", slug: "12345abc")
    end

    it "routes to #contributions" do
      expect(get: "#{url}/campaigns/12345abc/contributions").to route_to("campaigns#contributions", slug: "12345abc")
    end

    it "routes to #partner" do
      expect(get: "#{url}/campaigns/12345abc/partner").to route_to("campaigns#partner", slug: "12345abc")
    end

    it "routes to #thank_you" do
      expect(get: "#{url}/campaigns/12345abc/thank_you").to route_to("campaigns#thank_you", slug: "12345abc")
    end

  end
end
