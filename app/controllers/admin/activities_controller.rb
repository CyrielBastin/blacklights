class Admin::ActivitiesController < AdminController

  def index
    @activities = Activity.all
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    add_locations
    add_up_duplicate_equipment
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
    add_up_duplicate_equipment
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

  def add_up_duplicate_equipment
    return unless params[:activity][:activity_equipment_attributes].present?

    @activity.activity_equipment = []
    helpers.add_up_duplicates(params[:activity][:activity_equipment_attributes],
                              { id: :equipment_id, quantity: :quantity }).each do |key, value|
      @activity.activity_equipment << ActivityEquipment.new(activity_id: @activity, equipment_id: key, quantity: value)
    end
    params[:activity].delete(:activity_equipment_attributes)
  end

end
