require "rails_helper"

RSpec.describe Master::DistrictsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #index" do
      expect(get: "#{url}/districts").to route_to("master/districts#index")
    end

    it "routes to #new" do
      expect(get: "#{url}/districts/new").to route_to("master/districts#new")
    end

    it "routes to #show" do
      expect(get: "#{url}/districts/1").to route_to("master/districts#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "#{url}/districts/1/edit").to route_to("master/districts#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "#{url}/districts").to route_to("master/districts#create")
    end

    it "routes to #update" do
      expect(put: "#{url}/districts/1").to route_to("master/districts#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "#{url}/districts/1").to route_to("master/districts#destroy", id: "1")
    end

  end
end
