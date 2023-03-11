class GuessWord < ApplicationRecord
	enum Status: { Lost: 0, Playing: 1, Won: 2 }

  belongs_to :user, optional: true
  belongs_to :word
	has_many :guesses, class_name: 'GuessWordGuess', inverse_of: :guess_word, dependent: :destroy
end
