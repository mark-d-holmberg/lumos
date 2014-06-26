class AddAddressFieldsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :physical_address, :string
    add_column :campaigns, :physical_address_ext, :string
    add_column :campaigns, :physical_city, :string
    add_column :campaigns, :physical_state, :string
    add_column :campaigns, :physical_postal_code, :string
  end
end
