class CodeBreaker < ApplicationRecord
	enum Status: { Lost: 0, Playing: 1, Won: 2 }

  belongs_to :user, optional: true
	has_many :codes, class_name: 'CodeBreakerCode', inverse_of: :code_breaker, dependent: :destroy
  has_many :guesses, class_name: 'CodeBreakerGuess', inverse_of: :code_breaker, dependent: :destroy
end
