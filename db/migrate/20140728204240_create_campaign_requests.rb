class CreateCampaignRequests < ActiveRecord::Migration
  def change
    create_table :campaign_requests do |t|
      t.belongs_to :state, index: true
      t.string :district_name
      t.string :school_name
      t.string :teacher_name
      t.string :campaign_name
      t.boolean :school_wide, default: false
      t.string :email
      t.string :slug

      t.timestamps
    end
  end
end
