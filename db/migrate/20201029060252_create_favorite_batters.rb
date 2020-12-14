# frozen_string_literal: true

class CreateFavoriteBatters < ActiveRecord::Migration[6.0]
  def change
    create_table :favorite_batters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :batter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
