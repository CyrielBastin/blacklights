class Admin::UsersController < AdminController

  def index
    @users = User.active.page(params[:page]).per(15)
    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Utilisateurs.xlsx"' }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.profile.contact[:email] = params[:user][:email]
    if @user.save
      flash[:success] = 'L\'utilisateur a été crée avec succès !'
      redirect_to admin_users_path
    else
      render 'new'
    end
  end

  # def show
  # end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'L\'utilisateur a été modifié avec succès !'
      redirect_to admin_users_path
    else
      render 'edit'
    end
  end

  def invite
    @user = User.find(params[:user_id])
    @user.invite!
    flash[:success] = 'L\'utilisateur a été invité avec succès !'
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:id, :skip_password_validation, :_destroy, :email, :admin, profile_attributes:
      [:birthdate, :gender, contact_attributes: [:lastname, :firstname, :phone_number, :email, coordinate_attributes:
        [:street, :zip_code, :city, :country]]])
  end

end
