# frozen_string_literal: true

class FavoriteBattersController < ApplicationController
  before_action :set_batter
  before_action :authenticate_user!

  def create
    @favorite_batter = FavoriteBatter.create(user_id: current_user.id, batter_id: @batter.id)
    redirect_to registered_players_path, notice: '選手を登録しました'
  end

  def destroy
    @favorite_batter = FavoriteBatter.find_by(user_id: current_user.id, batter_id: @batter.id)
    @favorite_batter.destroy
    redirect_to registered_players_path, notice: '選手を登録解除しました'
  end

  private
  def set_batter
    @batter = Batter.find(params[:batter_id])
  end
end
