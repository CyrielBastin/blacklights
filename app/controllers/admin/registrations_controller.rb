class Admin::RegistrationsController < AdminController

  def index
    # We send a list of all events to come with their associated registrations in the view
    @events = Registration.for_events_to_come.page(params[:page]).per(10)
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

  def destroy
    Registration.find(params[:id]).destroy
    flash[:success] = 'Votre réservation a été supprimée avec succès !'

    redirect_to admin_registrations_path
  end

  private

  def registration_params
    params.require(:registration).permit(:event_id, :user_id, :confirmation_datetime,
                                         :price, :payment_confirmation_datetime)
  end

end
