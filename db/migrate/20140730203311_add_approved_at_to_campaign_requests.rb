class AddApprovedAtToCampaignRequests < ActiveRecord::Migration
  def change
    add_column :campaign_requests, :approved_at, :datetime
  end
end
