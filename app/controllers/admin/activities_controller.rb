class Admin::ActivitiesController < AdminController
  include ImportModel

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
    if @activity.save
      flash[:success] = 'Votre activité a été créée avec succès !'
      redirect_to admin_activities_path
    else
      render 'new'
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
    if @activity.update(activity_params)
      flash[:success] = 'Votre activité a été modifiée avec succès !'
      redirect_to admin_activities_path
    else
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

  def import_model
    import_activities
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
