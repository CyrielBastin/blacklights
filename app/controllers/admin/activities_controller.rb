class Admin::ActivitiesController < AdminController

  def index
    @activities = Activity.all
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity  = Activity.new(activity_params)
    if @activity.save
      flash[:success] = "Votre activité a été créée avec succès !"
      redirect_to admin_activities_path
    else
      render "new"
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
    if @activity.update(activity_params)
      flash[:success] = "Votre activité a été modifiée avec succès !"
      redirect_to admin_activities_path
    else
      render "edit"
    end
  end

  def destroy
    Activity.find(params[:id]).destroy
    flash[:success] = "Votre activité a été supprimée avec succès."
    redirect_to admin_activities_path
  end

  private

  def activity_params
    params.require(:activity).permit(:id, :name, :description)
  end

end
