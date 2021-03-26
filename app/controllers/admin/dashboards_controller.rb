class Admin::DashboardsController < AdminController

  def index
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

end
