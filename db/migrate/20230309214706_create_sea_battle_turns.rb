class CreateSeaBattleTurns < ActiveRecord::Migration[6.1]
  def change
    create_table :sea_battle_turns do |t|
      t.integer :ShipType
      t.integer :Navy
      t.integer :Target
      t.string :Horizontal, limit: 1
      t.integer :Vertical
      t.references :sea_battle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
