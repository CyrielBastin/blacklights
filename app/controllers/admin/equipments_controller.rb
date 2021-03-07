class Admin::EquipmentsController < AdminController

  def index
    @equipments = Equipment.order(:name)
  end

  def new
    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(equipment_params)
    if @equipment.save
      flash[:success] = 'Votre matériel a été crée avec succès !'
      redirect_to admin_equipments_path
    else
      render 'new'
    end
  end

  # def show
  #   @equipment = Equipment.find(params[:id])
  # end

  def edit
    @equipment = Equipment.find(params[:id])
  end

  def update
    @equipment = Equipment.find(params[:id])
    if @equipment.update(equipment_params)
      flash[:success] = 'Votre équipement a été modifié avec succès !'
      redirect_to admin_equipments_path
    else
      render 'edit'
    end
  end

  def destroy
    Equipment.find(params[:id]).destroy
    flash[:success] = 'Votre équipement a été supprimé avec succès !'
    redirect_to admin_equipments_path
  end

  private

  def equipment_params
    params.require(:equipment).permit(:name, :description, :unit_price, :category_id, :supplier_id,
                                      dimension_attributes: [:id, :width, :length, :height, :weight])
  end

end
