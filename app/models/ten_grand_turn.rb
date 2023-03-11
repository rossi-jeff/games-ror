class TenGrandTurn < ApplicationRecord
  belongs_to :ten_grand

	has_many :scores, class_name: 'TenGrandScore', inverse_of: :ten_grand_turn, dependent: :destroy
end
