class AddColumnsToPitchers < ActiveRecord::Migration[6.0]
  def change
    add_column :pitchers, :base_on_balls, :string
    add_column :pitchers, :hit_by_pitch, :string
  end
end
