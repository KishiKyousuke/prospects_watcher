class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @favorite_batters = current_user.favorite_batters.all
    @favorite_pitchers = current_user.favorite_pitchers.all
  end
end
