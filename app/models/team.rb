# frozen_string_literal: true

class Team < ApplicationRecord
  enum league: { central: 0, pacific: 1 }
  has_many :batters
  has_many :pitchers
end
