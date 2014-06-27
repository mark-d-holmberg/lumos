class CreateImpressions < ActiveRecord::Migration
  def change
    create_table :impressions do |t|
      t.string :email
      t.belongs_to :campaign, index: true
      t.string :referral_kind
      t.string :token

      t.timestamps
    end
  end
end
