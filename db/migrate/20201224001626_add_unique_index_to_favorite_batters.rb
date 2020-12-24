# frozen_string_literal: true

class AddUniqueIndexToFavoriteBatters < ActiveRecord::Migration[6.0]
  def change
    add_index :favorite_batters, [:user_id, :batter_id], unique: true
  end
end
