class Batter < ApplicationRecord
  has_many :favorite_batters, dependent: :destroy
end
