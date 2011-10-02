class BansController < ApplicationController
  respond_to :html
  
  def create
    @ban = current_user.bans.create params[:ban]
    respond_with @ban
  end
  
  def destroy
    @ban = Ban.find params[:id]
    @ban.destroy
    respond_with @ban
  end
  
  def edit
    @ban = Ban.find params[:id]
    respond_with @ban
  end
  
  def index
    @bans = Ban.order(:address)
    respond_with @bans
  end
  
  def new
    @ban = Ban.new
    respond_with @ban
  end
  
  def show
    @ban = Ban.find params[:id]
    respond_with @ban
  end
  
  def update
    @ban = Ban.find params[:id]
    @ban.update_attributes(params[:ban])
    respond_with @ban
  end
end
