# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :authenticate_user!

  def index
  end
end
