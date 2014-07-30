class AddPhysicalAddressFieldsToCampaignRequests < ActiveRecord::Migration
  def change
    add_column :campaign_requests, :physical_address, :string
    add_column :campaign_requests, :physical_address_ext, :string
    add_column :campaign_requests, :physical_city, :string
    add_column :campaign_requests, :physical_state, :string
    add_column :campaign_requests, :physical_postal_code, :string
  end
end
