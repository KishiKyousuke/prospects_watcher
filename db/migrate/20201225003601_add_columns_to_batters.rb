class AddColumnsToBatters < ActiveRecord::Migration[6.0]
  def change
    add_column :batters, :at_bat, :integer
    add_column :batters, :hits, :integer
  end
end
