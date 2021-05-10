class Admin::EntitiesController < AdminController
  include ImportModel

  def index
    @entities = Entity.all.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Associations.xlsx"' }
    end
  end

  def new
    @entity = Entity.new
  end

  def create
    @entity = Entity.new(entity_params)
    add_users
    add_locations
    add_activities
    add_events
    if @entity.save
      flash[:success] = 'Votre association a été créée avec succès !'
      redirect_to admin_entities_path
    else
      render 'new'
    end
  end

  def show
    @entity = Entity.find(params[:id])
  end

  def edit
    @entity = Entity.find(params[:id])
  end

  def update
    @entity = Entity.find(params[:id])
    add_users
    add_locations
    add_activities
    add_events
    if @entity.update(entity_params)
      flash[:success] = 'Votre association a été modifiée avec succès !'
      redirect_to admin_entities_path
    else
      render 'edit'
    end
  end

  def destroy
    Entity.find(params[:id]).destroy
    flash[:success] = 'Votre association a été supprimée avec succès !'
    redirect_to admin_entities_path
  end

  def import
    imported = import_entities(params[:file])
    if imported[:had_errors]
      err_msg = ''
      imported[:err_messages].each { |error| err_msg += "#{error}<br>" }
      flash[:danger] = err_msg
    else
      flash[:success] = 'Toutes vos associations ont été importées avec succès !'
    end
    redirect_to admin_entities_path
  end

  private

  def entity_params
    params.require(:entity).permit(:id, :name, :category_id,
                                   :entity_user_ids, :entity_location_ids, :entity_activity_ids, :entity_event_ids)
  end

  def update_params
    params[:entity][:category_id] = params[:entity][:category_id].split(',')[0]
    params[:entity][:entity_user_ids] = params[:entity][:entity_user_ids].split(',')
    params[:entity][:entity_location_ids] = params[:entity][:entity_location_ids].split(',')
    params[:entity][:entity_activity_ids] = params[:entity][:entity_activity_ids].split(',')
    params[:entity][:entity_event_ids] = params[:entity][:entity_event_ids].split(',')
  end

  def add_users
    @entity.entity_users = []
    params[:entity][:entity_user_ids].each do |user_id|
      unless user_id.empty?
        @entity.entity_users << EntityUser.new(entity_id: @entity, user_id: user_id)
      end
    end
  end

  def add_locations
    @entity.entity_locations = []
    params[:entity][:entity_location_ids].each do |location_id|
      unless location_id.empty?
        @entity.entity_locations << EntityLocation.new(entity_id: @entity, location_id: location_id)
      end
    end
  end

  def add_activities
    @entity.entity_activities = []
    params[:entity][:entity_activity_ids].each do |activity_id|
      unless activity_id.empty?
        @entity.entity_activities << EntityActivity.new(entity_id: @entity, activity_id: activity_id)
      end
    end
  end

  def add_events
    @entity.entity_events = []
    params[:entity][:entity_event_ids].each do |event_id|
      unless event_id.empty?
        @entity.entity_events << EntityEvent.new(entity_id: @entity, event_id: event_id)
      end
    end
  end

end
