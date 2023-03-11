class CodeBreakerGuessColor < ApplicationRecord
	enum Color: {
    Black: 0,
    Blue: 1,
    Brown: 2,
    Green: 3,
    Orange: 4,
    Purple: 5,
    Red: 6,
    White: 7,
    Yellow: 8
  }
	
  belongs_to :code_breaker_guess
end
