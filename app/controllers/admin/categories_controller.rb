class Admin::CategoriesController < AdminController

  def index
    @categories = Category.all.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Votre catégorie a été créée avec succès !"
      redirect_to admin_categories_path
    else
      render "new"
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
    if @category.update(category_params)
      flash[:success] = "Votre catégorie a été modifiée avec succès !"
      redirect_to admin_categories_path
    else
      render "edit"
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = "Votre catégorie a été supprimée avec succès."
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit( :parent_id, :name)
  end

end
