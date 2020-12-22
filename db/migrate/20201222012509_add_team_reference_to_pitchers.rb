class AddTeamReferenceToPitchers < ActiveRecord::Migration[6.0]
  def change
    add_reference :pitchers, :team, index: true, foreign_key: true
  end
end
