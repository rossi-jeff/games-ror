class TenGrandScore < ApplicationRecord
	DICE_REQUIRED = {
		Ones: 1,
		Fives: 1,
		ThreePairs: 6,
		Straight: 6,
		FullHouse: 5,
		DoubleThreeKind: 6,
		ThreeKind: 3,
		FourKind: 4,
		FiveKind: 5,
		SixKind: 6,
		CrapOut: 0
	}
	
	enum Category: {
		CrapOut: 0,
		Ones: 1,
		Fives: 2,
		ThreePairs: 3,
		Straight: 4,
		FullHouse: 5,
		DoubleThreeKind: 6,
		ThreeKind: 7,
		FourKind: 8,
		FiveKind: 9,
		SixKind: 10,
	}
	
  belongs_to :ten_grand_turn
end
