class Admin::DashboardsController < AdminController
  include ImportModel

  def index
    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Données exportées.xlsx"' }
    end
  end

  def import
    imported = import_all(params[:file])
    if imported[:had_errors]
      err_msg = ''
      imported[:err_messages].each { |error| err_msg += "#{error}<br>" }
      flash[:danger] = err_msg
    else
      flash[:success] = 'Toute votre Spreadsheet a été importée avec succès !'
    end
    redirect_to admin_root_path
  end

end
