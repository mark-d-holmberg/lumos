require "rails_helper"

RSpec.describe PublicController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/").to route_to("public#index")
    end

  end
end
