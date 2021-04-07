class Admin::CategoriesController < AdminController
  include ImportModel
  include DuplicateHelper

  def index
    @categories = Category.all.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Catégories.xlsx"' }
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if already_exists?(@category.class.name, :name, @category[:name])
      @category.errors.add(:name, message: 'Ce nom existe déjà dans la base de données !')
      render 'new'
    else
      if @category.save
        flash[:success] = 'Votre catégorie a été créée avec succès !'
        redirect_to admin_categories_path
      else
        render 'new'
      end
    end
  end

  # def show
  #   @activity = Activity.find(params[:id])
  # end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    cat = Category.find_by(name: params[:category][:name])
    if cat.nil? || cat[:id] == @category[:id]
      if @category.update(category_params)
        flash[:success] = 'Votre catégorie a été modifiée avec succès !'
        redirect_to admin_categories_path
      else
        render 'edit'
      end
    else
      @category.errors.add(:name, 'Ce nom existe déjà dans la base de données !')
      render 'edit'
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = "Votre catégorie a été supprimée avec succès."
    redirect_to admin_categories_path
  end

  def import
    imported = import_categories(params[:file])
    if imported[:had_errors]
      err_msg = ''
      imported[:err_messages].each { |error| err_msg += "#{error}<br>" }
      flash[:danger] = err_msg
    else
      flash[:success] = 'Toutes vos catégories ont été importés avec succès !'
    end
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:parent_id, :name, :category_for)
  end

end
