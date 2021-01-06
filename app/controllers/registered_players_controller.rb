# frozen_string_literal: true

class RegisteredPlayersController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorite_batters = current_user.favorite_batters.all
    @favorite_pitchers = current_user.favorite_pitchers.all
    @data_update_at = ScrapingLog.last.updated_at
  end
end
