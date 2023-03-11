class CreateSeaBattles < ActiveRecord::Migration[6.1]
  def change
    create_table :sea_battles do |t|
      t.integer :Axis, default: 8
      t.integer :Status, default: 1
      t.integer :Score,default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
