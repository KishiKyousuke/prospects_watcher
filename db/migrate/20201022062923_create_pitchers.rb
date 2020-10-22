class CreatePitchers < ActiveRecord::Migration[6.0]
  def change
    create_table :pitchers do |t|
      t.string :number
      t.string :name
      t.string :team
      t.float :earned_run_average
      t.integer :win
      t.integer :lose
      t.integer :strikeout
      t.string :innings_pitched
      t.integer :pitched
      t.integer :save
      t.integer :hold_point
      t.float :strikeouts_per_nine_innings
      t.float :strikeout_to_walk_ratio
      t.float :walks_and_hits_per_innings_pitched
      t.timestamps
    end
  end
end
