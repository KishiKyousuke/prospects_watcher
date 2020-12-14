# frozen_string_literal: true

class CreateBatters < ActiveRecord::Migration[6.0]
  def change
    create_table :batters do |t|
      t.string :number
      t.string :name
      t.string :team
      t.string :batting_average
      t.integer :home_run
      t.integer :runs_batted_in
      t.integer :stolen_base
      t.string :on_base_percentage
      t.string :on_base_plus_slugging
      t.integer :walks
      t.integer :hit_by_pitch
      t.string :scoring_position_batting_average
      t.integer :strikeout
      t.integer :error
      t.timestamps
    end
  end
end
