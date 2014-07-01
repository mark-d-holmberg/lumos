require "rails_helper"

RSpec.describe Master::TeachersController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me/schools/5" }

    it "routes to #index" do
      expect(get: "#{url}/teachers").to route_to("master/teachers#index", school_id: "5")
    end

    it "routes to #new" do
      expect(get: "#{url}/teachers/new").to route_to("master/teachers#new", school_id: "5")
    end

    it "routes to #show" do
      expect(get: "#{url}/teachers/1").to route_to("master/teachers#show", id: "1", school_id: "5")
    end

    it "routes to #edit" do
      expect(get: "#{url}/teachers/1/edit").to route_to("master/teachers#edit", id: "1", school_id: "5")
    end

    it "routes to #create" do
      expect(post: "#{url}/teachers").to route_to("master/teachers#create", school_id: "5")
    end

    it "routes to #update" do
      expect(put: "#{url}/teachers/1").to route_to("master/teachers#update", id: "1", school_id: "5")
    end

    it "routes to #destroy" do
      expect(delete: "#{url}/teachers/1").to route_to("master/teachers#destroy", id: "1", school_id: "5")
    end

  end
end
