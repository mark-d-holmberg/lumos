class AddImportedAtToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :imported_at, :datetime
  end
end
