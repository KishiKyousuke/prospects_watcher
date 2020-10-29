class BattersController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorite_batters = Batter.all
  end

  def create
    current_user.batter_id
  end
end
