class Admin::SuppliersController < AdminController
  include ImportModel
  include DuplicateHelper

  def index
    @suppliers = Supplier.all.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Fournisseurs.xlsx"' }
    end
  end

  def new
    @supplier = Supplier.new
    @user = User.new
  end

  def create
    @supplier = Supplier.new(supplier_params)
    @user = User.new(user_params)
    if name_already_exists?(@supplier.class.name, @supplier[:name])
      @supplier.errors.add(:name, message: 'Ce nom existe déjà dans la base de données !')
      render 'new'
    else
      if params[:creating_new_user] == '1'
        user_valid = @user.valid?; supplier_valid = @supplier.valid?
        if user_valid && supplier_valid
          @user.save
          add_users @user
          @supplier.save
          @supplier.supplier_users.each { |s_u| s_u.user.add_role :supplier }

          flash[:success] = 'Votre fournisseur a été crée avec succès !'
          redirect_to admin_suppliers_path
        else
          render 'new'
        end
      else
        if @supplier.valid?
          add_users @user
          @supplier.save
          @supplier.supplier_users.each { |s_u| s_u.user.add_role :supplier }

          flash[:success] = 'Votre fournisseur a été crée avec succès !'
          redirect_to admin_suppliers_path
        else
          render 'new'
        end
      end
    end
  end

  # def show
  #   @supplier = Supplier.find(params[:id])
  # end

  def edit
    @supplier = Supplier.find(params[:id])
    @user = User.new
  end

  def update
    @supplier = Supplier.find(params[:id])
    @supplier.assign_attributes(supplier_params)
    @user = User.new(user_params)
    sup = Supplier.find_by(name: params[:supplier][:name])
    if sup.nil? || sup[:id] == @supplier[:id]
      if params[:creating_new_user] == '1'
        user_valid = @user.valid?; supplier_valid = @supplier.valid?
        if user_valid && supplier_valid
          @user.save
          add_users @user
          @supplier.save
          @supplier.supplier_users.each { |s_u| s_u.user.add_role :supplier }

          flash[:success] = 'Votre fournisseur a été modifié avec succès !'
          redirect_to admin_suppliers_path
        else
          render 'edit'
        end
      else
        if @supplier.valid?
          add_users @user
          @supplier.save
          @supplier.supplier_users.each { |s_u| s_u.user.add_role :supplier }

          flash[:success] = 'Votre fournisseur a été modifié avec succès !'
          redirect_to admin_suppliers_path
        else
          render 'edit'
        end
      end
    else
      @supplier.errors.add(:name, 'Ce nom existe déjà dans la base de données !')
      render 'edit'
    end
  end

  def destroy
    Supplier.find(params[:id]).destroy
    flash[:success] = 'Votre fournisseur a été supprimé avec succès !'
    redirect_to admin_suppliers_path
  end

  def import
    imported = import_suppliers(params[:file])
    if imported[:had_errors]
      err_msg = ''
      imported[:err_messages].each { |error| err_msg += "#{error}<br>" }
      flash[:danger] = err_msg
    else
      flash[:success] = 'Tous vos fournisseurs ont été importés avec succès !'
    end
    redirect_to admin_suppliers_path
  end

  private

  def supplier_params
    params.require(:supplier).permit(:id, :name, :email, :phone_number, :country, :zip_code, :city, :supplier_user_ids)
  end

  def user_params
    params.require(:user).permit(:id, :skip_password_validation, :_destroy, :email, profile_attributes:
      [:birthdate, :gender, contact_attributes: [:lastname, :firstname, :phone_number, :email]])
  end

  def update_params
    params[:supplier][:supplier_user_ids] = params[:supplier][:supplier_user_ids].split(',')
    params[:user][:profile_attributes][:contact_attributes][:email] = params[:user][:email]
  end

  def add_users(new_user)
    unless @supplier.supplier_users.empty?
      @supplier.supplier_users.each { |s_u| s_u.user.remove_role :supplier }
      @supplier.supplier_users = []
    end
    params[:supplier][:supplier_user_ids].each do |user_id|
      unless user_id.empty?
        @supplier.supplier_users << SupplierUser.new(supplier_id: @supplier, user_id: user_id)
      end
    end
    if params[:creating_new_user] == '1'
      @supplier.supplier_users << SupplierUser.new(supplier_id: @supplier, user_id: new_user[:id])
    end
  end

end
