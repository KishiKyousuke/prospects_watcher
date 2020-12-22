# frozen_string_literal: true

class Pitcher < ApplicationRecord
  has_many :favorite_pitchers, dependent: :destroy
  belongs_to :team
end
