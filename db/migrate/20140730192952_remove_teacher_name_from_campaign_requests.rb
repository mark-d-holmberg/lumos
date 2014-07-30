class RemoveTeacherNameFromCampaignRequests < ActiveRecord::Migration
  def change
    remove_column :campaign_requests, :teacher_name
  end
end
