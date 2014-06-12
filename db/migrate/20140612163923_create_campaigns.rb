class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.belongs_to :state, index: true
      t.belongs_to :district, index: true
      t.belongs_to :school, index: true
      t.belongs_to :teacher, index: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
