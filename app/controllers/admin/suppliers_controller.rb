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
  end

  def create
    @supplier = Supplier.new(supplier_params)
    add_users
    if name_already_exists?(@supplier.class.name, @supplier[:name])
      @supplier.errors.add(:name, message: 'Ce nom existe déjà dans la base de données !')
      render 'new'
    else
      if @supplier.save
        flash[:success] = 'Votre fournisseur a été crée avec succès !'
        redirect_to admin_suppliers_path
      else
        render 'new'
      end
    end
  end

  # def show
  #   @supplier = Supplier.find(params[:id])
  # end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def update
    @supplier = Supplier.find(params[:id])
    add_users
    sup = Supplier.find_by(name: params[:supplier][:name])
    if sup.nil? || sup[:id] == @supplier[:id]
      if @supplier.update(supplier_params)
        flash[:success] = 'Votre fournisseur a été modifié avec succès !'
        redirect_to admin_suppliers_path
      else
        render 'edit'
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

  def update_params
    params[:supplier][:supplier_user_ids] = params[:supplier][:supplier_user_ids].split(',')
  end

  def add_users
    @supplier.supplier_users = []
    params[:supplier][:supplier_user_ids].each do |user_id|
      unless user_id.empty?
        @supplier.supplier_users << SupplierUser.new(supplier_id: @supplier, user_id: user_id)
      end
    end
    if params[:creating_new_user] == '1'
      u = create_new_user
      @supplier.supplier_users << SupplierUser.new(supplier_id: @supplier, user_id: u[:id]) if u.save
    end
  end

  def create_new_user
    u = User.new
    p = Profile.new
    c = Contact.new
    c[:email] = params[:user][:email]
    c[:lastname] = params[:user][:profile_attributes][:contact_attributes][:lastname]
    c[:firstname] = params[:user][:profile_attributes][:contact_attributes][:firstname]
    c[:phone_number] = params[:user][:profile_attributes][:contact_attributes][:phone_number]
    p[:gender] = params[:user][:profile_attributes][:gender]
    p.contact = c
    u[:email] = params[:user][:email]
    u[:admin] = params[:user][:admin] == '1'
    u.skip_password_validation = true
    u.profile = p

    u
  end

end
