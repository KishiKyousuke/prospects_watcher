# frozen_string_literal: true

class AddTeamReferenceToBatters < ActiveRecord::Migration[6.0]
  def change
    add_reference :batters, :team, index: true, foreign_key: true
  end
end
