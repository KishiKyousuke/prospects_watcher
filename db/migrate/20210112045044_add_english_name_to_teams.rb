# frozen_string_literal: true

class AddEnglishNameToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :english_name, :string
  end
end
