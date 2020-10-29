class CreateFavoritePitchers < ActiveRecord::Migration[6.0]
  def change
    create_table :favorite_pitchers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pitcher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
