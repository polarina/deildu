# encoding: utf-8

class PostsController < ApplicationController
  respond_to :html
  
  def create
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.find params[:topic_id]
    @post = @topic.posts.new params[:post]
    @post.user = current_user
    @post.save
    @recent_posts = @topic.posts.order{created_at.desc}.includes(:user).limit(3)
    respond_with @forum, @topic, @post, :location => forum_topic_path(@forum, @topic, :page => "p#{@post.id}", :anchor => "post#{@post.id}")
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
    @post.post = ""
    @recent_posts = @topic.posts.order{created_at.desc}.includes(:user).limit(3)
    
    if params[:quote]
      @quote = Post.find params[:quote]
      
      @post.post << "> _**#{@quote.user.username}** skrifaði:_\n>\n"
      
      @quote.post.to_s.each_line do |line|
        @post.post << "> " + line
      end
      
      @post.post << "\n\n"
    end
    
    respond_with @forum, @topic, @post
  end
  
  def update
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.find params[:topic_id]
    @post = @topic.posts.find params[:id]
    @post.update_attributes params[:post]
    respond_with @forum, @topic, @post, :location => forum_topic_path(@forum, @topic, :page => "p#{@post.id}", :anchor => "post#{@post.id}")
  end
end
