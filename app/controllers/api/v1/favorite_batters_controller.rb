# frozen_string_literal: true

class Api::V1::FavoriteBattersController < ActionController::API
  before_action :authenticate_user!

  def create
    current_user.favorite_batters.create!(batter_id: params[:player_id])
  end

  def destroy
    current_user.favorite_batters.find_by(batter_id: params[:player_id]).destroy!
  end
end
