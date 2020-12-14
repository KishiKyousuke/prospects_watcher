# frozen_string_literal: true

class RegisteredPlayersController < ApplicationController
  def index
    @favorite_batters = current_user.favorite_batters.all
    @favorite_pitchers = current_user.favorite_pitchers.all
  end
end
