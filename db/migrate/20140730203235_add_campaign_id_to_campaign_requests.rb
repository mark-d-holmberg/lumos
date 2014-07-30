class AddCampaignIdToCampaignRequests < ActiveRecord::Migration
  def change
    add_reference :campaign_requests, :campaign, index: true
  end
end
