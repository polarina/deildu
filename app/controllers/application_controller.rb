class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  before_filter :is_forbidden
  before_filter :requires_authentication
  
  private

  def current_user
    @current_user ||= User.find_by_id(session[:userid]) if session[:userid]
  end
  
  def is_forbidden
    maddress = request.ip
    
    if Ban.select(1).where{address.op('>>=', maddress)}.first
      render 'public/403', :layout => false, :status => :forbidden
    elsif current_user and not current_user.allowed
      render 'public/403', :layout => false, :status => :forbidden
    end
  end
  
  def requires_authentication
    if current_user.nil?
      @user = User.new
      @return = request.url
      
      render 'users/auth', :status => :forbidden
    end
  end
end
