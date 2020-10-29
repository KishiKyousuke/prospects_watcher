class FavoritePitchersController < ApplicationController
  before_action :set_pitcher
  before_action :authenticate_user!

  def create
    @favorite_pitcher = FavoritePitcher.create(user_id: current_user.id, pitcher_id: @pitcher.id)
    redirect_to user_path(current_user), notice: '選手を登録しました'
  end

  def destroy
    @favorite_pitcher = FavoritePitcher.find_by(user_id: current_user.id, pitcher_id: @pitcher.id)
    @favorite_pitcher.destroy
    redirect_to user_path(current_user), notice: '選手を登録解除しました'
  end

  private
  def set_pitcher
    @pitcher = Pitcher.find(params[:pitcher_id])
  end
end
