class Pitcher < ApplicationRecord
  has_many :favorite_pitchers, dependent: :destroy
end
