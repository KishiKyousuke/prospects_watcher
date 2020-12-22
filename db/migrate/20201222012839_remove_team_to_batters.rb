# frozen_string_literal: true

class RemoveTeamToBatters < ActiveRecord::Migration[6.0]
  def change
    remove_column :batters, :team, :string
  end
end
