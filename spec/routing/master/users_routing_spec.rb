require "rails_helper"

RSpec.describe Master::UsersController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #index" do
      expect(get: "#{url}/users").to route_to("master/users#index")
    end

    it "routes to #new" do
      expect(get: "#{url}/users/new").to route_to("master/users#new")
    end

    it "routes to #show" do
      expect(get: "#{url}/users/1").to route_to("master/users#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "#{url}/users/1/edit").to route_to("master/users#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "#{url}/users").to route_to("master/users#create")
    end

    it "routes to #update" do
      expect(put: "#{url}/users/1").to route_to("master/users#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "#{url}/users/1").to route_to("master/users#destroy", id: "1")
    end

  end
end
