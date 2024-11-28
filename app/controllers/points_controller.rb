class PointsController < ApplicationController

  def show
    @point = Point.find(params[:id])
  end
end