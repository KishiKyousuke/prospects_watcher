class AddPlateAppearanceToBatters < ActiveRecord::Migration[6.0]
  def change
    add_column :batters, :plate_appearance, :string
  end
end
