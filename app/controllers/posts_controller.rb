class PostsController < ApplicationController
  respond_to :html
  
  def create
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.find params[:topic_id]
    @post = @topic.posts.new params[:post]
    @post.user = current_user
    @post.save
    respond_with @forum, @topic, @post, :location => forum_topic_path(@forum, @topic)
  end
  
  def new
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.find params[:topic_id]
    @post = @topic.posts.new
    respond_with @forum, @topic, @post
  end
end
