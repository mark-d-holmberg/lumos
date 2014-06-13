class CreateTos < ActiveRecord::Migration
  def change
    create_table :tos do |t|
      t.text :content

      t.timestamps
    end
  end
end
