class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.integer :pledge_id
      t.date :pledged_at
      t.belongs_to :contributor, index: true
      t.belongs_to :campaign, index: true
      t.money :amount

      t.timestamps
    end
  end
end
