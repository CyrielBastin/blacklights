class Admin::ActivitiesController < AdminController
  include ImportModel
  include DuplicateHelper

  def index
    @activities = Activity.all.page(params[:page]).per(6)
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    add_locations
    if already_exists?(@activity.class.name, :name, @activity[:name])
      @activity.errors.add(:name, message: 'Ce nom existe déjà dans la base de données !')
      render 'new'
    else
      if @activity.save
        flash[:success] = 'Votre activité a été créée avec succès !'
        redirect_to admin_activities_path
      else
        render 'new'
      end
    end
  end

  # def show
  #   @activity = Activity.find(params[:id])
  # end

  def edit
    @activity = Activity.find(params[:id])
  end

  def update
    @activity = Activity.find(params[:id])
    add_locations
    act = Activity.find_by(name: params[:activity][:name])
    if act.nil? || act[:id] == @activity[:id]
      if @activity.update(activity_params)
        flash[:success] = 'Votre activité a été modifiée avec succès !'
        redirect_to admin_activities_path
      else
        render 'edit'
      end
    else
      @activity.errors.add(:name, 'Ce nom existe déjà dans la base de données !')
      render 'edit'
    end
  end

  def destroy
    Activity.find(params[:id]).destroy
    flash[:success] = 'Votre activité a été supprimée avec succès.'
    redirect_to admin_activities_path
  end

  def location_activities_json
    render json: Activity.get_activities_by_location_id(params[:loc_id])
  end

  def import
    imported = import_activities
    if imported[:had_errors]
      err_msg = ''
      imported[:errors].each { |error| err_msg += "#{error}<br>" }
      flash[:danger] = err_msg
    else
      flash[:success] = 'Toutes vos activités ont été importées avec succès !'
    end
    redirect_to admin_activities_path
  end

  private

  def activity_params
    params.require(:activity).permit(:id, :name, :description,
                                     :location_activity_ids,
                                     activity_equipment_attributes: [:id, :equipment_id, :quantity, :_destroy])
  end

  def add_locations
    @activity.location_activities = []
    params[:activity][:location_activity_ids].each do |location_id|
      unless location_id.empty?
        @activity.location_activities << LocationActivity.new(activity_id: @activity, location_id: location_id)
      end
    end
  end

end
