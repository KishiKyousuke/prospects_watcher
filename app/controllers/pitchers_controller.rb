class PitchersController < ApplicationController
  def index
    @pitchers = Pitcher.all
  end
end
