class YachtTurn < ApplicationRecord
	enum Category: {
		BigStraight: 0,
		Choice: 1,
		Fives: 2,
		FourOfKind: 3,
		Fours: 4,
		FullHouse: 5,
		LittleStraight: 6,
		Ones: 7,
		Sixes: 8,
		Threes: 9,
		Twos: 10,
		Yacht: 11
	}
	
  belongs_to :yacht
end
