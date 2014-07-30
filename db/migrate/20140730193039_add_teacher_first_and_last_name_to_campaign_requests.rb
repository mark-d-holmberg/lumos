class AddTeacherFirstAndLastNameToCampaignRequests < ActiveRecord::Migration
  def change
    add_column :campaign_requests, :teacher_first_name, :string
    add_column :campaign_requests, :teacher_last_name, :string
  end
end
