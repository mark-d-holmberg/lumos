require "rails_helper"

RSpec.describe Api::V1::DistrictsController, type: :routing do
  describe "routing" do
    let(:url) { "http://www.lvh.me/api/v1" }

    it "routes to #index" do
      expect(get: "#{url}/districts.json").to route_to("api/v1/districts#index", format: 'json')
    end

  end
end
