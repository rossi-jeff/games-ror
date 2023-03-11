class CreateTenGrandScores < ActiveRecord::Migration[6.1]
  def change
    create_table :ten_grand_scores do |t|
      t.string :Dice, limit: 20
      t.integer :Category, default: 0
      t.integer :Score, default: 0
      t.references :ten_grand_turn, null: false, foreign_key: true

      t.timestamps
    end
  end
end
