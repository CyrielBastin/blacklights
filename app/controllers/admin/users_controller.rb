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
    add_entities
    if @user.save
      @user.add_role(:admin) if params[:user_admin].present?
      @user.add_role(:organizer) if params[:user_organizer].present?
      @user.add_role(:supplier) if params[:user_supplier].present?
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
    add_entities
    if @user.update(user_params)
      params[:user_admin].present? ? @user.add_role(:admin) : @user.remove_role(:admin)
      params[:user_organizer].present? ? @user.add_role(:organizer) : @user.remove_role(:organizer)
      params[:user_supplier].present? ? @user.add_role(:supplier) : @user.remove_role(:supplier)
      flash[:success] = 'L\'utilisateur a été modifié avec succès !'
      redirect_to admin_users_path
    else
      render 'edit'
    end
  end

  def destroy
    u = User.find(params[:id])
    if u.update(deleted_at: DateTime.now)
      flash[:success] = 'L\'utilisateur a été supprimé avec succès !'
      redirect_to admin_users_path
    end
  end

  def invite
    @user = User.find(params[:user_id])
    @user.invite!
    flash[:success] = 'L\'utilisateur a été invité avec succès !'
    redirect_to admin_users_path
  end

  def multiple_select
    case params[:to_do]
    when 'delete'
      multiple_delete
    when 'invite'
      multiple_invite
    else
      ''
    end

    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:id, :skip_password_validation, :_destroy, :email, :entity_user_ids, profile_attributes:
      [:birthdate, :gender, contact_attributes: [:lastname, :firstname, :phone_number, :email, coordinate_attributes:
        [:street, :zip_code, :city, :country]]])
  end

  def update_params
    params[:user][:entity_user_ids] = params[:user][:entity_user_ids].split(',')
  end

  def add_entities
    @user.entity_users = []
    params[:user][:entity_user_ids].each do |entity_id|
      unless entity_id.empty?
        @user.entity_users << EntityUser.new(entity_id: entity_id, user_id: @user)
      end
    end
  end

  def multiple_delete
    return if params[:list_user_ids].nil?

    params[:list_user_ids].each do |id|
      u = User.find(id)
      u.update(deleted_at: DateTime.now)
    end
  end

  def multiple_invite
    return if params[:list_user_ids].nil?

    params[:list_user_ids].each do |id|
      # TODO
      # Call invite method for each user id
    end
  end

end
