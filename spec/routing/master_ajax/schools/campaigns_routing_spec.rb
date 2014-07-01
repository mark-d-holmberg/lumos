require "rails_helper"

RSpec.describe MasterAjax::Schools::CampaignsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me/master_ajax/schools/123" }

    it "routes to #new" do
      expect(get: "#{url}/campaigns/new").to route_to("master_ajax/schools/campaigns#new", school_id: "123")
    end

    it "routes to #create" do
      expect(post: "#{url}/campaigns").to route_to("master_ajax/schools/campaigns#create", school_id: "123")
    end

  end
end
