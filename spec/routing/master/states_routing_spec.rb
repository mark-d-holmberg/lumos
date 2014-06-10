require "rails_helper"

RSpec.describe Master::StatesController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #index" do
      expect(get: "#{url}/states").to route_to("master/states#index")
    end

    it "routes to #new" do
      expect(get: "#{url}/states/new").to route_to("master/states#new")
    end

    it "routes to #show" do
      expect(get: "#{url}/states/1").to route_to("master/states#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "#{url}/states/1/edit").to route_to("master/states#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "#{url}/states").to route_to("master/states#create")
    end

    it "routes to #update" do
      expect(put: "#{url}/states/1").to route_to("master/states#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "#{url}/states/1").to route_to("master/states#destroy", id: "1")
    end

  end
end
