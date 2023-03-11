class CreateTenGrandTurns < ActiveRecord::Migration[6.1]
  def change
    create_table :ten_grand_turns do |t|
      t.integer :Score, default: 0
      t.references :ten_grand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
