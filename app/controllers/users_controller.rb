class UsersController < ApplicationController
  skip_before_filter :requires_authentication, :only => [:new, :create, :auth]
  
  respond_to :html
  
  def create
    if @invitation = Invitation.find_by_key(params[:invitation])
      @user = User.new params[:user].merge({ :email => @invitation.email })
      @user.inviter = @invitation.user
      @user.save
      
      Invitation.destroy_all(:email => @invitation.email) unless @user.new_record?
      session[:userid] = @user.id unless @user.new_record?
      
      respond_with @user, :location => root_path
    else
      redirect_to new_user_path
    end
  end
  
  def index
    respond_with(@users = User.order(:username))
  end
  
  def show
    respond_with(@user = User.find_by_username!(params[:id]))
  end
  
  def new
    @invitation = Invitation.find_by_key(params[:invitation])
    @user = User.new
    @user.email = @invitation.email unless @invitation.nil?
    respond_with @user
  end
  
  def auth
    if request.get?
      if current_user.nil?
        @user = User.new
        respond_with @user
      else
        redirect_to root_path
      end
    end
    
    if request.post?
      @user = User.find_by_username(params[:user][:username]).try(:authenticate, params[:user][:password])
      
      if @user
        session[:userid] = @user.id
        
        unless params[:return].nil?
          redirect_to params[:return]
        else
          redirect_to root_path
        end
      else
        redirect_to auth_users_path
      end
    end
    
    if request.delete?
      session[:userid] = nil
      redirect_to root_path
    end
  end
end
