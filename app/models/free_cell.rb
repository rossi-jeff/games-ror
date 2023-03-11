class FreeCell < ApplicationRecord
  belongs_to :user, optional: true
end
