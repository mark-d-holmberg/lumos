require "rails_helper"

RSpec.describe Api::V1::TeachersController, type: :routing do
  describe "routing" do
    let(:url) { "http://www.lvh.me/api/v1/schools/1" }

    it "routes to #index" do
      expect(get: "#{url}/teachers.json").to route_to("api/v1/teachers#index", format: 'json', school_id: '1')
    end

  end
end
