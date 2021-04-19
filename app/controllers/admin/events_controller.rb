class Admin::EventsController < AdminController
  include DuplicateHelper
  include ImportModel

  def index
    if params[:events] == 'previous'
      @events = Event.previous.page(params[:page]).per(7)
      events_to_come = false
    else
      @events = Event.to_come.page(params[:page]).per(7)
      events_to_come = true
    end

    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Evènements.xlsx"' }
    end

    render 'index', locals: { :@events => @events, :events_to_come => events_to_come }
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

  def show
    @event = Event.find(params[:id])
    event_equipment = add_up_duplicates(assemble_all_equipment_together,
                                        id: :equipment_name,
                                        quantity: :quantity)
    render 'show', locals: { :@event => @event,
                             :event_equipment => event_equipment,
                             :event_to_come => @event[:start_date] > DateTime.now }
  end

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

  def import
    imported = import_events(params[:file])
    if imported[:had_errors]
      err_msg = ''
      imported[:err_messages].each { |error| err_msg += "#{error}<br>" }
      flash[:danger] = err_msg
    else
      flash[:success] = 'Tous vos évènements ont été importés avec succès !'
    end
    redirect_to admin_events_path
  end

  def import_registrations_per_event
    event_id = params[:id].split(' ')[1]
    imported = import_event_registrations(params[:file], event_id)
    if imported[:had_errors]
      err_msg = ''
      imported[:err_messages].each { |error| err_msg += "#{error}<br>" }
      flash[:danger] = err_msg
    else
      flash[:success] = 'Toutes vos réservations ont été importées avec succès !'
    end
    redirect_to admin_event_path(event_id)
  end

  private

  def event_params
    params.require(:event).permit(:name, :start_date, :end_date, :registration_deadline, :min_participant, :max_participant, :price, :location_id,
                                  contact_attributes: [:id, :lastname, :firstname, :phone_number, :email, coordinate_attributes: [:id, :street, :zip_code, :city, :country]],
                                  event_activities_attributes: [:id, :activity_id, :simultaneous_activities, :_destroy],
                                  event_equipment_attributes: [:id, :equipment_id, :quantity, :_destroy])
  end


  # This function gets all the equipment for an event together inside an array of objects(hash)
  # example: [{ "equipment_name": "aa", "quantity": 1" }, { "equipment_name": "bb", "quantity": "2" }]
  # That is in order to handle the duplicates afterward
  def assemble_all_equipment_together
    equipment_assembled = []
    if @event.event_activities.present?
      @event.event_activities.each do |ev_ac|
        if ev_ac.activity.activity_equipment.present?
          ev_ac.activity.activity_equipment.each do |ac_eq|
            equipment_assembled << { equipment_name: ac_eq.equipment.name,
                                     quantity: ac_eq.quantity * ev_ac.simultaneous_activities }
          end
        end
      end
    end
    if @event.event_equipment.present?
      @event.event_equipment.each do |ev_eq|
        equipment_assembled << { equipment_name: ev_eq.equipment.name,
                                 quantity: ev_eq.quantity }
      end
    end

    equipment_assembled
  end

end
