require "rails_helper"

RSpec.describe Master::SearchesController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #index" do
      expect(get: "#{url}/searches").to route_to("master/searches#index")
    end

  end
end
