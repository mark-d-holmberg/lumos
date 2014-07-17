require "rails_helper"

RSpec.describe Master::ReportsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #pending_impressions" do
      expect(get: "#{url}/reports/pending_impressions").to route_to("master/reports#pending_impressions")
    end

    it "routes to #index" do
      expect(get: "#{url}/reports").to route_to("master/reports#index")
    end

  end
end
