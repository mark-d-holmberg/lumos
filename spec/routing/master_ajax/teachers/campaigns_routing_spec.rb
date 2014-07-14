require "rails_helper"

RSpec.describe MasterAjax::Teachers::CampaignsController, type: :routing do
  describe "routing" do
    let(:url) { "http://master.lvh.me/master_ajax/teachers/123" }

    it "routes to #new" do
      expect(get: "#{url}/campaigns/new").to route_to("master_ajax/teachers/campaigns#new", teacher_id: "123")
    end

    it "routes to #create" do
      expect(post: "#{url}/campaigns").to route_to("master_ajax/teachers/campaigns#create", teacher_id: "123")
    end

  end
end
