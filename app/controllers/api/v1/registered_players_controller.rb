# frozen_string_literal: true

class Api::V1::RegisteredPlayersController < ActionController::API
  before_action :authenticate_user!

  def index
    @batters = current_user.batters
    @pitchers = current_user.pitchers
  end
end
