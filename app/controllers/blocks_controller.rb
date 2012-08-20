class BlocksController < ApplicationController
  respond_to :html
  
  def create
    @block = current_user.blocks.create :blocked => User.find_by_username!(params[:user])
    
    respond_with @block, :location => blocks_path do |format|
      format.html { redirect_to blocks_path }
    end
  end
  
  def destroy
    @block = current_user.blocks.find_by_blocked_id!(User.find_by_username!(params[:id]).id)
    @block.destroy
    respond_with @block
  end
  
  def index
    @blocks = current_user.blocks.order(:created_at)
    respond_with @blocks
  end
end
