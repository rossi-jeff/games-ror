class Yacht < ApplicationRecord
  belongs_to :user, optional: true
	has_many :turns, class_name: 'YachtTurn', inverse_of: :yacht, dependent: :destroy
end
