class AddGoalAmountToCampaigns < ActiveRecord::Migration
  def change
    add_money :campaigns, :goal_amount
  end
end
