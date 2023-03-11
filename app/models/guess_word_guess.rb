class GuessWordGuess < ApplicationRecord
  belongs_to :guess_word
	has_many :ratings, class_name: 'GuessWordGuessRating', inverse_of: :guess_word_guess, dependent: :destroy
end
