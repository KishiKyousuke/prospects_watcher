class BattersController < ApplicationController
  def index
    @batters = Batter.all
  end
end
