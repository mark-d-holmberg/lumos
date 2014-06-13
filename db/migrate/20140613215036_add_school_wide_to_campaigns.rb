class AddSchoolWideToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :school_wide, :boolean, default: false
  end
end
