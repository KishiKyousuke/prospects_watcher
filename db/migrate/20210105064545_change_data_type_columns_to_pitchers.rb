class ChangeDataTypeColumnsToPitchers < ActiveRecord::Migration[6.0]
  def up
    change_column :pitchers, :earned_run_average,:string
    change_column :pitchers, :win,:string
    change_column :pitchers, :lose,:string
    change_column :pitchers, :strikeout,:string
    change_column :pitchers, :pitched,:string
    change_column :pitchers, :number_of_save,:string
    change_column :pitchers, :hold_point,:string
    change_column :pitchers, :strikeouts_per_nine_innings,:string
    change_column :pitchers, :strikeout_to_walk_ratio,:string
    change_column :pitchers, :walks_and_hits_per_innings_pitched,:string
  end
  
  def down
    change_column :pitchers, :earned_run_average,:float
    change_column :pitchers, :win,:integer
    change_column :pitchers, :lose,:integer
    change_column :pitchers, :strikeout,:integer
    change_column :pitchers, :pitched,:integer
    change_column :pitchers, :number_of_save,:integer
    change_column :pitchers, :hold_point,:integer
    change_column :pitchers, :strikeouts_per_nine_innings,:float
    change_column :pitchers, :strikeout_to_walk_ratio,:float
    change_column :pitchers, :walks_and_hits_per_innings_pitched,:float
  end
end
