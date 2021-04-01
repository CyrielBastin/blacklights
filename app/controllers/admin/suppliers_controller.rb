class Admin::SuppliersController < AdminController
  include ImportModel
  include DuplicateHelper

  def index
    @suppliers = Supplier.all.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def new
    @supplier = Supplier.new
    @supplier.contact = Contact.new
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if already_exists?(@supplier.class.name, :name, @supplier[:name])
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

  def show
    @supplier = Supplier.find(params[:id])
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def update
    @supplier = Supplier.find(params[:id])
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
    imported = import_suppliers
    if imported[:had_errors]
      err_msg = ''
      imported[:errors].each { |error| err_msg += "#{error}<br>" }
      flash[:danger] = err_msg
    else
      flash[:success] = 'Tous vos fournisseurs ont été importés avec succès !'
    end
    redirect_to admin_suppliers_path
  end

  private

  def supplier_params
    params.require(:supplier).permit(:id, :name, contact_attributes: [:id, :lastname, :firstname, :phone_number, :email, coordinate_attributes: [:id, :street, :zip_code, :city, :country]])
  end

end
