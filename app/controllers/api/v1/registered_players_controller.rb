# frozen_string_literal: true

class Api::V1::RegisteredPlayersController < ActionController::API
  before_action :authenticate_user!

  def index
    favorite_players = { batters: current_user.favorite_batters.all, pitchers: current_user.favorite_pitchers.all }
    render json: favorite_players
  end
end
