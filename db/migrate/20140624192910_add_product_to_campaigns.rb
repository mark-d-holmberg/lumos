class AddProductToCampaigns < ActiveRecord::Migration
  def change
    add_reference :campaigns, :product, index: true
  end
end
