class InvitationsController < ApplicationController
  respond_to :html
  
  def create
    @invitation = Invitation.new params[:invitation]
    @invitation.user = current_user
    
    if @invitation.save
      respond_to do |format|
        format.html { redirect_to invitations_path }
      end
    else
      respond_to do |format|
        @invitations = Invitation.where(:user_id => current_user.id)
        @invitees = current_user.invitees
        format.html { render :action => "index" }
      end
    end
  end
  
  def index
    @invitation = Invitation.new
    @invitees = current_user.invitees
    respond_with(@invitations = Invitation.where(:user_id => current_user.id))
  end
  
  def destroy
    Invitation.where(:user_id => current_user.id, :key => params[:id]).destroy_all
    redirect_to invitations_path
  end
end
