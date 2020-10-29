class FavoriteBatter < ApplicationRecord
  belongs_to :user
  belongs_to :batter
end
