# frozen_string_literal: true

class FavoritePitcher < ApplicationRecord
  belongs_to :user
  belongs_to :pitcher
end
