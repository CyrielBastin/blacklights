class Admin::SuppliersController < AdminController

  def index
    @suppliers = Supplier.order(:name)
  end

  def new
    @supplier = Supplier.new
    @supplier.contact = Contact.new
  end

  def create
    @supplier = Supplier.new(supplier_params)
    @supplier.contact = Contact.new(contact_params)
    @supplier.contact.coordinate = Coordinate.new(coordinate_params)
    if @supplier.save
      flash[:success] = 'Votre fournisseur a été crée avec succès !'
      redirect_to admin_suppliers_path
    else
      render 'new'
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
    if @supplier.update(supplier_params)
      flash[:success] = 'Votre fournisseur a été modifié avec succès !'
      redirect_to admin_suppliers_path
    else
      render 'edit'
    end
  end

  def destroy
    supplier = Supplier.find(params[:id])
    supplier.contact.coordinate.destroy
    supplier.contact.destroy
    supplier.destroy
    flash[:success] = 'Votre fournisseur a été supprimé avec succès.'
    redirect_to admin_suppliers_path
  end

  private

  def supplier_params
    params.require(:supplier).permit(:id, :name)
  end

  def contact_params
    params.require(:contact).permit(:id, :lastname, :firstname, :phone_number, :email)
  end

  def coordinate_params
    params.require(:coordinate).permit(:id, :street, :zip_code, :city, :country)
  end

end
