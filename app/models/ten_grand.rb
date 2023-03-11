class TenGrand < ApplicationRecord
	enum Status: { Lost: 0, Playing: 1, Won: 2 }

  belongs_to :user, optional: true
	has_many :turns, class_name: 'TenGrandTurn', inverse_of: :ten_grand, dependent: :destroy
end
