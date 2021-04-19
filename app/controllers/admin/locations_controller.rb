class Admin::LocationsController < AdminController
  include ImportModel
  include DuplicateHelper

  def index
    @locations = Location.all.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Lieux.xlsx"' }
    end
  end

  def new
    @location = Location.new
  end

  def create
    update_location_params
    @location = Location.new(location_params)
    add_activities
    if name_already_exists?(@location.class.name, @location[:name])
      @location.errors.add(:name, message: 'Ce nom existe déjà dans la base de données !')
      render 'new'
    else
      if @location.save
        flash[:success] = 'Votre lieu a été crée avec succès !'
        redirect_to admin_locations_path
      else
        render 'new'
      end
    end
  end

  # def show
  #   @location = Location.find(params[:id])
  # end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    update_location_params
    @location = Location.find(params[:id])
    add_activities
    loc = Location.find_by(name: params[:location][:name])
    if loc.nil? || loc[:id] == @location[:id]
      if @location.update(location_params)
        flash[:success] = 'Votre lieu a été modifié avec succès !'
        redirect_to admin_locations_path
      else
        render 'edit'
      end
    else
      @location.errors.add(:name, 'Ce nom existe déjà dans la base de données !')
      render 'edit'
    end
  end

  def destroy
    location = Location.find(params[:id])
    location.destroy
    flash[:success] = 'Votre lieu a été supprimé avec succès !'
    redirect_to admin_locations_path
  end

  def import
    imported = import_locations(params[:file])
    if imported[:had_errors]
      err_msg = ''
      imported[:err_messages].each { |error| err_msg += "#{error}<br>" }
      flash[:danger] = err_msg
    else
      flash[:success] = 'Tous vos lieux ont été importés avec succès !'
    end
    redirect_to admin_locations_path
  end

  private

  def location_params
    params.require(:location).permit(:id, :location_activity_ids, :name, :type, :capacity, :street, :zip_code, :city, :country,
                                     contact_attributes: [:id, :lastname, :firstname, :phone_number, :email,
                                                          coordinate_attributes: [:id, :street, :zip_code, :city, :country]],
                                     dimension_attributes: [:id, :width, :length, :height, :weight])
  end

  def update_location_params
    params[:location][:location_activity_ids] = params[:location][:location_activity_ids].split(',')
  end

  def add_activities
    @location.location_activities = []
    params[:location][:location_activity_ids].each do |activity_id|
      unless activity_id.empty?
        @location.location_activities << LocationActivity.new(activity_id: activity_id, location_id: @location)
      end
    end
  end

end
