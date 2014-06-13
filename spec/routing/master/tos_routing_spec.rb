require "rails_helper"

RSpec.describe Master::TosController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #show" do
      expect(get: "#{url}/tos").to route_to("master/tos#show")
    end

    it "routes to #edit" do
      expect(get: "#{url}/tos/edit").to route_to("master/tos#edit")
    end

    it "routes to #update" do
      expect(put: "#{url}/tos").to route_to("master/tos#update")
    end

  end
end
