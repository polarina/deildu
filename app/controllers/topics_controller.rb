class TopicsController < ApplicationController
  respond_to :html
  
  def create
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.new params[:topic]
    @topic.user = current_user
    @topic.save
    respond_with @forum, @topic
  end
  
  def destroy
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.find params[:id]
    @topic.destroy
    respond_with @forum, @topic
  end
  
  def show
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.find params[:id]
    respond_with @forum, @topic
  end
  
  def new
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.new
    respond_with @forum, @topic
  end
end
