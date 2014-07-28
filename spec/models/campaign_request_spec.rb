require 'rails_helper'

RSpec.describe CampaignRequest, type: :model do
  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:campaign_request)).to be_valid
    end

    it "should require a state" do
      expect(build(:campaign_request, state_id: nil)).to_not be_valid
    end
  end
end
