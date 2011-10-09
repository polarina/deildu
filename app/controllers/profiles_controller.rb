# encoding: utf-8

class ProfilesController < ApplicationController
  respond_to :html
  
  def update
    @user = current_user
    
    case params[:change]
    when "basic" then
      @user.update_attributes params[:user]
      if @user.valid?
        flash[:notice] = "Prófíll uppfærður."
        redirect_to profile_path
      else
        render 'show'
      end
    when "identity" then
      @user.update_passkey
      if @user.save
        flash[:notice] = "Auðkenni endursett."
        redirect_to profile_path
      else
        render 'show'
      end
    when "password" then
      if @user.authenticate params[:user][:current_password]
        @user.update_attributes params[:user]
      else
        @user.errors.add(:current_password, "is incorrect")
      end
      
      if @user.errors.empty?
        flash[:notice] = "Lykilorði hefur verið breytt."
        redirect_to profile_path
      else
        render 'show'
      end
    end
  end
  
  def show
    @user = current_user
  end
end
