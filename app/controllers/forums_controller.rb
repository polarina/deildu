class ForumsController < ApplicationController
  def index
  end
  
  def show
    redirect_to posts_path(params[:id])
  end
end
