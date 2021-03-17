class Admin::EventsController < AdminController

  def index
    @events = Event.order(:start_date)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    add_up_duplicate_activities
    add_up_duplicate_equipment
    if @event.save
      flash[:success] = 'Votre évènement a été crée avec succès !'
      redirect_to admin_events_path
    else
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
    event_equipment = helpers.add_up_duplicates(assemble_all_equipment_together, { id: :equipment_name, quantity: :quantity })

    render 'show', locals: { :@event => @event, :event_equipment => event_equipment }
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    add_up_duplicate_activities
    add_up_duplicate_equipment
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
    params.require(:event).permit(:name, :start_date, :end_date, :registration_deadline, :min_participant, :max_participant, :price, :location_id,
                                  contact_attributes: [:id, :lastname, :firstname, :phone_number, :email, coordinate_attributes: [:id, :street, :zip_code, :city, :country]],
                                  event_activities_attributes: [:id, :activity_id, :simultaneous_activities, :_destroy],
                                  event_equipment_attributes: [:id, :equipment_id, :quantity, :_destroy])
  end

  def add_up_duplicate_activities
    return unless params[:event][:event_activities_attributes].present?

    @event.event_activities = []
    helpers.add_up_duplicates(params[:event][:event_activities_attributes],
                              { id: :activity_id, quantity: :simultaneous_activities }).each do |key, value|
      @event.event_activities << EventActivity.new(event_id: @event, activity_id: key, simultaneous_activities: value)
    end
    params[:event].delete(:event_activities_attributes)
  end

  def add_up_duplicate_equipment
    return unless params[:event][:event_equipment_attributes].present?

    @event.event_equipment = []
    helpers.add_up_duplicates(params[:event][:event_equipment_attributes],
                              { id: :equipment_id, quantity: :quantity }).each do |key, value|
      @event.event_equipment << EventEquipment.new(event_id: @event, equipment_id: key, quantity: value)
    end
    params[:event].delete(:event_equipment_attributes)
  end

  # This function gets all the equipment for an event together inside an hash of hashes
  # example: { "1": { "equipment_name": "aa", "quantity": 1" }, "2": { "equipment_name": "bb", "quantity": "2" } }
  # That is in order to handle the duplicates afterward
  def assemble_all_equipment_together
    equipment_assembled = {}
    index = 1
    if @event.event_activities.present?
      @event.event_activities.each do |ev_ac|
        if ev_ac.activity.activity_equipment.present?
          ev_ac.activity.activity_equipment.each do |ac_eq|
            equipment_assembled[index] = { equipment_name: ac_eq.equipment.name,
                                           quantity: ac_eq.quantity * ev_ac.simultaneous_activities }
            index += 1
          end
        end
      end
    end
    if @event.event_equipment.present?
      @event.event_equipment.each do |ev_eq|
        equipment_assembled[index] = { equipment_name: ev_eq.equipment.name,
                                       quantity: ev_eq.quantity }
        index += 1
      end
    end

    equipment_assembled
  end

end
