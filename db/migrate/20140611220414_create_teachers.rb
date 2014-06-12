class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :first_name
      t.string :last_name
      t.belongs_to :school, index: true

      t.timestamps
    end
  end
end
