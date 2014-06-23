require "rails_helper"

RSpec.describe Api::V1::SchoolsController, type: :routing do
  describe "routing" do
    let(:url) { "http://www.lvh.me/api/v1/districts/1" }

    it "routes to #index" do
      expect(get: "#{url}/schools.json").to route_to("api/v1/schools#index", format: 'json', district_id: '1')
    end

  end
end
