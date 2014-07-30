class AddProductIdToCampaignRequests < ActiveRecord::Migration
  def change
    add_reference :campaign_requests, :product, index: true
  end
end
