class TopicsController < ApplicationController
  respond_to :html
  
  def create
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.new params[:topic]
    @topic.user = current_user
    @post = Post.new params[:topic][:post]
    @post.user = current_user
    
    ActiveRecord::Base.transaction do
      if @topic.save
        @post.topic = @topic
        @post.save
      end
      
      raise ActiveRecord::Rollback unless @topic.persisted? and @post.persisted?
    end
    
    @post.valid?
    
    respond_to do |format|
      if @topic.persisted? and @post.persisted?
        format.html { redirect_to forum_topic_path(@forum, @topic) }
      else
        format.html { render 'new' }
      end
    end
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
    
    if params[:page] =~ /^p([0-9]+)$/ and $1
      post_id = $1
      post = Post.select{created_at}.where{id == post_id}
      count = @topic.posts.where("created_at < (#{post.to_sql})").count
      params[:page] = count / Post.per_page + 1
    end
    
    @posts = @topic.posts.order{created_at.asc}.includes(:user).page(params[:page])
    @new_post = @topic.posts.new
    
    last_post = ReadTopic.find_or_initialize_by_user_id_and_topic_id(current_user.id, @topic.id)
    
    if last_post.post and @posts.last
      last_post.update_attributes!(:post_id => @posts.last.id) if last_post.post.created_at < @posts.last.created_at
    end
    
    respond_with @forum, @topic
  end
  
  def new
    @forum = Forum.find params[:forum_id]
    @topic = @forum.topics.new
    @post = @topic.posts.new
    respond_with @forum, @topic
  end
end
