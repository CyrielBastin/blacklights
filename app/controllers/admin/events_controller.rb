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
    add_activities
    add_entities
    add_equipment
    if @event.save
      @event.user.add_role :organizer
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
    @event.user.remove_role :organizer # We remove organizer role from user in case the user is changed
    add_activities
    add_entities
    add_equipment
    if @event.update(event_params)
      @event.user.add_role :organizer
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
    params.require(:event).permit(:name, :start_date, :end_date, :category_id, :registration_deadline, :min_participant,
                                  :max_participant, :price, :type, :location_id, :user_id,
                                  :event_category_ids, :event_activity_ids, :entity_event_ids, :event_equipment_ids,
                                  :event_registration_ids,
                                  user_attributes: [:email, :skip_password_validation,
                                                    profile_attributes: [:gender, contact_attributes: [:email, :lastname, :firstname, :phone_number]]])
  end

  def update_params
    params[:event][:location_id] = params[:event][:location_id].split(',')[0]
    params[:event][:event_activity_ids] = params[:event][:event_activity_ids].split(',')
    params[:event][:entity_event_ids] = params[:event][:entity_event_ids].split(',')
    params[:event][:event_equipment_ids] = params[:event][:event_equipment_ids].split(',')
    params[:event][:event_registration_ids] = params[:event][:event_registration_ids].split(',')
    params[:event][:type] = params[:event][:type] == '1' ? 'public' : 'private'
    if params[:creating_new_user] == '0'
      params[:event] = params[:event].except(:user_attributes)
    end
  end

  def add_activities
    @event.event_activities = []
    return if params[:event][:event_activity_ids].empty?

    list_activities = params[:event][:event_activity_ids].zip(params[:list_activity_qty])
    list_activities.each do |ac_q|
      next if ac_q[1].to_i <= 0

      unless ac_q[1].empty?
        @event.event_activities << EventActivity.new(event_id: @event, activity_id: ac_q[0], quantity: ac_q[1])
      end
    end
  end

  def add_entities
    @event.entity_events = []
    params[:event][:entity_event_ids].each do |entity_id|
      unless entity_id.empty?
        @event.entity_events << EntityEvent.new(entity_id: entity_id, event_id: @event)
      end
    end
  end

  def add_equipment
    @event.event_equipment = []
    return if params[:event][:event_equipment_ids].empty?

    list_equipment = params[:event][:event_equipment_ids].zip(params[:list_equipment_qty])
    list_equipment.each do |eq_q|
      unless eq_q[1].empty?
        @event.event_equipment << EventEquipment.new(event_id: @event, equipment_id: eq_q[0], quantity: eq_q[1])
      end
    end
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
                                     quantity: ac_eq.quantity * ev_ac.quantity }
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
