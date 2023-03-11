class SeaBattleTurn < ApplicationRecord
	enum ShipType: {
		BattleShip: 0,
		Carrier: 1,
		Cruiser: 2,
		PatrolBoat: 3,
		SubMarine: 4
	}
	enum Navy: { Player: 0, Opponent: 1 }
	enum Target: { Miss: 0, Hit: 1, Sunk: 2 }
	
  belongs_to :sea_battle
end
