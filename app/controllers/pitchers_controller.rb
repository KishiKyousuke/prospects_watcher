class PitchersController < ApplicationController
  before_action :authenticate_user!

  def index
    @pitchers = Pitcher.all
  end
end
