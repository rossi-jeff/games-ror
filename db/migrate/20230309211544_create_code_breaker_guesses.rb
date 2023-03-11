class CreateCodeBreakerGuesses < ActiveRecord::Migration[6.1]
  def change
    create_table :code_breaker_guesses do |t|
      t.references :code_breaker, null: false, foreign_key: true

      t.timestamps
    end
  end
end
