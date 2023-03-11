class CreateYachtTurns < ActiveRecord::Migration[6.1]
  def change
    create_table :yacht_turns do |t|
      t.string :RollOne, limit: 20, default: ""
      t.string :RollTwo, limit: 20, default: ""
      t.string :RollThree, limit: 20, default: ""
      t.integer :Category
      t.integer :Score, default: 0
      t.references :yacht, null: false, foreign_key: true

      t.timestamps
    end
  end
end
