class AddUniqueIndexToFavoritePitchers < ActiveRecord::Migration[6.0]
  def change
    add_index :favorite_pitchers, [:user_id, :pitcher_id], unique: true
  end
end
