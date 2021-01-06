class AddResultToScrapingLog < ActiveRecord::Migration[6.0]
  def change
    add_column :scraping_logs, :result, :string
  end
end
