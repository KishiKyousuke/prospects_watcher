# frozen_string_literal: true

class Api::V1::FavoritePitchersController < ActionController::API
  before_action :authenticate_user!

  def create
    current_user.favorite_pitchers.create!(pitcher_id: params[:player_id])
  end

  def destroy
    current_user.favorite_pitchers.find_by(pitcher_id: params[:player_id]).destroy!
  end
end
