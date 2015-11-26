class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_cache_control_headers

  def set_cache_control_headers
    expires_in 1.day, :public => true
  end
end
