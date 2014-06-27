class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_impression
    @current_impression ||= Impression.find_by_token!(cookies[:impression_token]) if (cookies[:impression_token])
  end
  helper_method :current_impression

end
