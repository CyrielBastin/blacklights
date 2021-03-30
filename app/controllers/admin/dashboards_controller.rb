class Admin::DashboardsController < AdminController
  include ImportModel

  def index
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def import_models
    import_all
    redirect_to admin_root_path
  end

end
