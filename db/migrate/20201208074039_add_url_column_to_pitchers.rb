class AddUrlColumnToPitchers < ActiveRecord::Migration[6.0]
  def change
    add_column :pitchers, :url, :string
  end
end
