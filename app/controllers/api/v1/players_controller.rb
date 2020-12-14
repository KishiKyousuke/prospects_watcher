# frozen_string_literal: true

class Api::V1::PlayersController < ActionController::API
  def index
    batters = Batter.select(:id, :number, :name, :team)
    pitchers = Pitcher.select(:id, :number, :name, :team)
    players_data_formatter = PlayersDataFormatter.new(batters, pitchers)
    players_data_formatter.run
    players_data = players_data_formatter.all_data
    render json: players_data
  end
end
