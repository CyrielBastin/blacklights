class Admin::LocationsController < AdminController

  def index
    @locations = Location.order(:name)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      flash[:success] = 'Votre lieu a été crée avec succès !'
      redirect_to admin_locations_path
    else
      render 'new'
    end
  end

  # def show
  #   @location = Location.find(params[:id])
  # end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update(location_params)
      flash[:success] = 'Votre lieu a été modifié avec succès !'
      redirect_to admin_locations_path
    else
      render 'edit'
    end
  end

  def destroy
    Location.find(params[:id]).destroy

    flash[:success] = 'Votre lieu a été supprimé avec succès !'
    redirect_to admin_locations_path
  end

  private

  def location_params
    params.require(:location).permit(:id, :name, :type)
  end

end
