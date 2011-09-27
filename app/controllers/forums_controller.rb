class ForumsController < ApplicationController
  respond_to :html
  
  def create
    @forum = Forum.create params[:forum]
    respond_with @forum, :location => forums_path
  end
  
  def destroy
    @forum = Forum.find params[:id]
    @forum.destroy
    respond_with @forum
  end
  
  def index
    respond_with(@forums = Forum.overview)
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
