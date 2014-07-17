class AddImpressionTokenToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :impression_token, :string
  end
end
