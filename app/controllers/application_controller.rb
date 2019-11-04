class ApplicationController < ActionController::Base
  before_action :gon_user

  helper_method :gon_user

  # rescue_from CanCan::AccessDenied do |exception|
  #   redirect_to root_url, alert: exception.message
  # end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
