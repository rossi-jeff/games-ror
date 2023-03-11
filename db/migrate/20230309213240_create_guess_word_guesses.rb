class CreateGuessWordGuesses < ActiveRecord::Migration[6.1]
  def change
    create_table :guess_word_guesses do |t|
      t.string :Guess, limit: 30
      t.references :guess_word, null: false, foreign_key: true

      t.timestamps
    end
  end
end
