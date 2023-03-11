class CreateYachts < ActiveRecord::Migration[6.1]
  def change
    create_table :yachts do |t|
      t.integer :Total, default: 0
      t.integer :NumTurns, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
