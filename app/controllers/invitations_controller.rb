class InvitationsController < ApplicationController
  respond_to :html
  
  def create
    @user = User.find_by_username! params[:user_id]
    @invitation = Invitation.new params[:invitation]
    @invitation.user = @user
    
    if @invitation.save
      respond_to do |format|
        format.html { redirect_to user_invitations_path(@user) }
      end
    else
      respond_to do |format|
        @invitations = Invitation.where(:user_id => @user.id)
        @invitees = @user.invitees
        format.html { render :action => "index" }
      end
    end
  end
  
  def index
    @user = User.find_by_username! params[:user_id]
    @invitation = Invitation.new
    @invitees = @user.invitees
    respond_with(@invitations = Invitation.where(:user_id => @user.id))
  end
  
  def destroy
    @user = User.find_by_username! params[:user_id]
    Invitation.where(:user_id => @user.id, :key => params[:id]).destroy_all
    redirect_to user_invitations_path
  end
end
