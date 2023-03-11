class CodeBreakerGuessKey < ApplicationRecord
	enum Key: {
    Black: 0,
    White: 1,
  }
	
  belongs_to :code_breaker_guess
end
