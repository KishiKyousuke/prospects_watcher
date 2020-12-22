# frozen_string_literal: true

class AddUrlIdColumnToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :url_id, :integer, null: false
  end
end
