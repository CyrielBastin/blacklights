class AdminController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  #before_action :authenticate_user!, :check_admin

  #layout "admin"

  def set_locale
    I18n.locale = current_user.locale
  rescue I18n::InvalidLocale
    I18n.locale = 'fr'
  end

  def check_admin
    unless current_user && current_user.admin?
      redirect_to root_path, notice: "Vous n'avez pas les droits d'accéder à cette page"
    end
  end
end
