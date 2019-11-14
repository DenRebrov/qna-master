class ApplicationController < ActionController::Base
  before_action :gon_user

  helper_method :gon_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.json { head :forbidden }
      format.js { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
