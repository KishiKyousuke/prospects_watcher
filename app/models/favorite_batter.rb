# frozen_string_literal: true

class FavoriteBatter < ApplicationRecord
  validates :user_id,  uniqueness: { scope: :batter_id }
  belongs_to :user
  belongs_to :batter
end
