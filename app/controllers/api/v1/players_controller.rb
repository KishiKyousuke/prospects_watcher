# frozen_string_literal: true

class Api::V1::PlayersController < ActionController::API
  def index
    teams = Team.order(:ranking)
    batters = Batter.select(:id, :number, :name, :team_id)
    pitchers = Pitcher.select(:id, :number, :name, :team_id)
    players_data_formatter = PlayersDataFormatter.new(teams, batters, pitchers)
    players_data = players_data_formatter.run
    render json: players_data
  end
end
