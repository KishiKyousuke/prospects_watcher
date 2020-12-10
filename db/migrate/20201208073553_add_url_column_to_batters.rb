class AddUrlColumnToBatters < ActiveRecord::Migration[6.0]
  def change
    add_column :batters, :url, :string
  end
end
