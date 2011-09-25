class ForumsController < ApplicationController
  respond_to :html
  
  def create
    @forum = Forum.create params[:forum]
    respond_with @forum
  end
  
  def destroy
  end
  
  def index
    respond_with(@forums = Forum.order("ordering asc").all)
  end
  
  def edit
    respond_with(@forum = Forum.find(params[:id]))
  end
  
  def new
    respond_with(@forum = Forum.new)
  end
  
  def show
    @forum = Forum.find params[:id]
    @topics = @forum.topics
    respond_with @forum
  end
  
  def update
    @forum = Forum.find params[:id]
    @forum.update_attributes params[:forum]
    @forum.save
    respond_with @forum
  end
end
