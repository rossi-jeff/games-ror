class SeaBattleShip < ApplicationRecord
	enum Type: {
		BattleShip: 0,
		Carrier: 1,
		Cruiser: 2,
		PatrolBoat: 3,
		SubMarine: 4
	}
	enum Navy: { Player: 0, Opponent: 1 }

  belongs_to :sea_battle
	has_many :points, class_name: 'SeaBattleShipGridPoint',  inverse_of: :sea_battle_ship, dependent: :destroy
	has_many :hits, class_name: 'SeaBattleShipHit',  inverse_of: :sea_battle_ship, dependent: :destroy
end
