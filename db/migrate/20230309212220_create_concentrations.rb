class CreateConcentrations < ActiveRecord::Migration[6.1]
  def change
    create_table :concentrations do |t|
      t.integer :Status, default: 1
      t.integer :Moves, default: 0
      t.integer :Matched, default: 0
      t.integer :Elapsed, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
