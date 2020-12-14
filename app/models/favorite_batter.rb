# frozen_string_literal: true

class FavoriteBatter < ApplicationRecord
  belongs_to :user
  belongs_to :batter
end
