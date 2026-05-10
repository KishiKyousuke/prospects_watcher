class FavoritePitcher < ApplicationRecord
  validates :user_id,  uniqueness: { scope: :pitcher_id }
  belongs_to :user
  belongs_to :pitcher
end
