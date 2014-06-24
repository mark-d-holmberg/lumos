class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.binary :description
      t.money :price

      t.timestamps
    end
  end
end
