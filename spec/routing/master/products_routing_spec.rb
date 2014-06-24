require "rails_helper"

RSpec.describe Master::ProductsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me" }

    it "routes to #index" do
      expect(get: "#{url}/products").to route_to("master/products#index")
    end

    it "routes to #new" do
      expect(get: "#{url}/products/new").to route_to("master/products#new")
    end

    it "routes to #show" do
      expect(get: "#{url}/products/1").to route_to("master/products#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "#{url}/products/1/edit").to route_to("master/products#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "#{url}/products").to route_to("master/products#create")
    end

    it "routes to #update" do
      expect(put: "#{url}/products/1").to route_to("master/products#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "#{url}/products/1").to route_to("master/products#destroy", id: "1")
    end

  end
end
