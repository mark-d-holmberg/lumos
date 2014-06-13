class AddCampaignableToCampaigns < ActiveRecord::Migration
  def change
    rename_column :campaigns, :teacher_id, :campaignable_id
    add_column :campaigns, :campaignable_type, :string
  end
end
