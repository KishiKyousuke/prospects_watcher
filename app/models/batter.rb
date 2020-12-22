# frozen_string_literal: true

class Batter < ApplicationRecord
  has_many :favorite_batters, dependent: :destroy
  belongs_to :team
end
