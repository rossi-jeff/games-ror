class CreateGuessWordGuessRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :guess_word_guess_ratings do |t|
      t.integer :Rating
      t.references :guess_word_guess, null: false, foreign_key: true

      t.timestamps
    end
  end
end
