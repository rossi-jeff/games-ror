class SeaBattle < ApplicationRecord
	enum Status: { Lost: 0, Playing: 1, Won: 2 }

  belongs_to :user, optional: true
	has_many :ships, class_name: 'SeaBattleShip',  inverse_of: :sea_battle, dependent: :destroy
	has_many :turns, class_name: 'SeaBattleTurn',  inverse_of: :sea_battle, dependent: :destroy
end
