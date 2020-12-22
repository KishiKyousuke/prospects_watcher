class RemoveTeamToPitchers < ActiveRecord::Migration[6.0]
  def change
    remove_column :pitchers, :team, :string
  end
end
