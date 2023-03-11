class Klondike < ApplicationRecord
	enum Status: { Lost: 0, Playing: 1, Won: 2 }
	
  belongs_to :user, optional: true
end
