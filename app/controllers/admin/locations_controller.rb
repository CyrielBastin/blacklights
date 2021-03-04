class Admin::LocationsController < AdminController

  def index
    @locations = Location.order(:name)
  end

  def new
    @location = Location.new
  end
  
  def create
  end

  def show
    @location = Location.find(params[:id])
  end

  def edit
    @location = Location.find(params[:id])
  end

end
