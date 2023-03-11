class CodeBreakerGuess < ApplicationRecord
  belongs_to :code_breaker
	has_many :colors, class_name: 'CodeBreakerGuessColor', inverse_of: :code_breaker_guess, dependent: :destroy
  has_many :keys, class_name: 'CodeBreakerGuessKey', inverse_of: :code_breaker_guess, dependent: :destroy
end
