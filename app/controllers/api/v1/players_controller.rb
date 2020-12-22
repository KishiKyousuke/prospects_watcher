# frozen_string_literal: true

class Api::V1::PlayersController < ActionController::API
  def index
    teams = Team.order(:ranking)
    players_data_formatter = PlayersDataFormatter.new(teams)
    players_data = players_data_formatter.run
    render json: players_data
  end
end
