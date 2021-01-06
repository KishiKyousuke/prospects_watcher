# frozen_string_literal: true

class CreateScrapingLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :scraping_logs do |t|
      t.timestamps
    end
  end
end
