class ActivitiesController < ApplicationController

  def index
    @activities = Activity.visible
    @categories = Category.for_activity
  end

  def show
    @activity = Activity.find(params[:id])
  end

end
