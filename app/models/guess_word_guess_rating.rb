class GuessWordGuessRating < ApplicationRecord
	enum Rating: { Gray: 0, Brown: 1, Green: 2 }
	
  belongs_to :guess_word_guess
end
