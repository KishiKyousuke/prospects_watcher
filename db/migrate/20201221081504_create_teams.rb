# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :formal_name, null: false
      t.integer :ranking, null: false
      t.integer :league, null: false

      t.timestamps
    end
  end
end
