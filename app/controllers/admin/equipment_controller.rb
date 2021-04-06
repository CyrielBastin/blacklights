class Admin::EquipmentController < AdminController
  include ImportModel

  def index
    @equipments = Equipment.all.page(params[:page]).per(6)
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def new
    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(equipment_params)
    if @equipment.save
      flash[:success] = 'Votre matériel a été crée avec succès !'
      redirect_to admin_equipment_index_path
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
      flash[:success] = 'Votre matériel a été modifié avec succès !'
      redirect_to admin_equipment_index_path
    else
      render 'edit'
    end
  end

  def destroy
    Equipment.find(params[:id]).destroy
    flash[:success] = 'Votre matériel a été supprimé avec succès !'
    redirect_to admin_equipment_index_path
  end

  def import
    imported = import_equipment(params[:file])
    if imported[:had_errors]
      err_msg = ''
      imported[:err_messages].each { |error| err_msg += "#{error}<br>" }
      flash[:danger] = err_msg
    else
      flash[:success] = 'Tout votre matériel a été importé avec succès !'
    end
    redirect_to admin_equipment_index_path
  end

  private

  def equipment_params
    params.require(:equipment).permit(:name, :description, :unit_price, :category_id, :supplier_id, dimension_attributes: [:id, :width, :length, :height, :weight])
  end

end
