require "rails_helper"

RSpec.describe Master::ImportsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #import_schools via GET" do
      expect(get: "#{url}/imports/schools").to route_to("master/imports#schools")
    end

    it "routes to #import_schools via POST" do
      expect(post: "#{url}/imports/schools").to route_to("master/imports#schools")
    end

  end
end
