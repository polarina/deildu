class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  before_filter :requires_authorization
  
  private

  def current_user
    @current_user ||= User.find_by_id(session[:userid]) if session[:userid]
  end
  
  def requires_authorization
    if current_user.nil?
      @user = User.new
      @return = request.url
      
      render 'users/auth', :status => :forbidden
    end
  end
end
