class Admin::EventsController < AdminController

  def index
    @events = Event.order(:name)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:success] = 'Votre évènement a été crée avec succès !'
      redirect_to admin_events_path
    else
      render 'new'
    end
  end

  # def show
  #   @event = Event.find(params[:id])
  # end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:success] = 'Votre évènement a été modifié avec succès !'
      redirect_to admin_events_path
    else
      render 'edit'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = 'Votre évènement a été supprimé avec succès !'
    redirect_to admin_events_path
  end

  private

  def event_params
    params.require(:event).permit(:start_date, :end_date, :registration_deadline, :min_participant, :max_participant, :price, :location_id,
                                  contact_attributes: [:id, :lastname, :firstname, :phone_number, :email, coordinate_attributes: [:id, :street, :zip_code, :city, :country]],
                                  event_activity_equipment_attributes: [:id, :activity_id, :quantity, :_destroy])
  end

end
