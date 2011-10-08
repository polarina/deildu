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
  
  def destroy
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.find params[:topic_id]
    @post = @topic.posts.find params[:id]
    @post.destroy
    respond_with @forum, @topic, @post
  end
  
  def edit
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.find params[:topic_id]
    @post = @topic.posts.find params[:id]
    respond_with @forum, @topic, @post
  end
  
  def new
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.find params[:topic_id]
    @post = @topic.posts.new
    respond_with @forum, @topic, @post
  end
  
  def update
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.find params[:topic_id]
    @post = @topic.posts.find params[:id]
    @post.update_attributes params[:post]
    respond_with @forum, @topic, @post, :location => forum_topic_path(@forum, @topic)
  end
end
