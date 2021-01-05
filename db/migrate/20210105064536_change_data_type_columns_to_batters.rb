# frozen_string_literal: true

class ChangeDataTypeColumnsToBatters < ActiveRecord::Migration[6.0]
  def up
    change_column :batters, :home_run, :string
    change_column :batters, :runs_batted_in, :string
    change_column :batters, :stolen_base, :string
    change_column :batters, :walks, :string
    change_column :batters, :hit_by_pitch, :string
    change_column :batters, :strikeout, :string
    change_column :batters, :error, :string
    change_column :batters, :at_bat, :string
    change_column :batters, :hits, :string
  end

  def down
    change_column :batters, :home_run, :integer
    change_column :batters, :runs_batted_in, :integer
    change_column :batters, :stolen_base, :integer
    change_column :batters, :walks, :integer
    change_column :batters, :hit_by_pitch, :integer
    change_column :batters, :strikeout, :integer
    change_column :batters, :error, :integer
    change_column :batters, :at_bat, :integer
    change_column :batters, :hits, :integer
  end
end
