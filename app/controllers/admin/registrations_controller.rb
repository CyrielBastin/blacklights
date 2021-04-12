class Admin::RegistrationsController < AdminController
  include ImportModel

  def index
    # We send a list of all events to come with their associated registrations in the view
    @events = Registration.for_events_to_come.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Réservations.xlsx"' }
    end
  end

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.save
      flash[:success] = 'Votre réservation a été créée avec succès !'

      redirect_to admin_registrations_path
    else
      render 'new'
    end
  end

  def edit
    @registration = Registration.find(params[:id])
  end

  def update
    @registration = Registration.find(params[:id])

    if @registration.update(registration_params)
      flash[:success] = 'Votre réservation a été modifiée avec succès !'

      redirect_to admin_registrations_path
    else
      render 'edit'
    end
  end

  def confirm
    @registration = Registration.find(params[:registration_id])
    case params[:type]
    when 'confirmation'
      redirect_to admin_registrations_path if @registration.update(confirmation_datetime: 2.hours.from_now)
    when 'payment_confirmation'
      @registration[:confirmation_datetime] = 2.hours.from_now if @registration[:confirmation_datetime].nil?
      redirect_to admin_registrations_path if @registration.update(payment_confirmation_datetime: 2.hours.from_now)
    else
      redirect_to admin_registrations_path
    end
  end

  def destroy
    Registration.find(params[:id]).destroy
    flash[:success] = 'Votre réservation a été supprimée avec succès !'

    redirect_to admin_registrations_path
  end

  def import
    imported = import_registrations(params[:file])
    if imported[:had_errors]
      err_msg = ''
      imported[:err_messages].each { |error| err_msg += "#{error}<br>" }
      flash[:danger] = err_msg
    else
      flash[:success] = 'Toutes vos réservations ont été importés avec succès !'
    end
    redirect_to admin_registrations_path
  end

  private

  def registration_params
    params.require(:registration).permit(:event_id, :user_id, :confirmation_datetime,
                                         :price, :payment_confirmation_datetime)
  end

end
