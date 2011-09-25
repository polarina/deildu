class CommentsController < ApplicationController
  respond_to :html
  
  def create
    @torrent = Torrent.find params[:torrent_id]
    @comment = @torrent.comments.new(params[:comment])
    
    @comment.user = current_user
    @comment.torrent = @torrent
    @comment.save
    
    respond_with @torrent, @comment, :location => torrent_path(@torrent)
  end
  
  def destroy
    @torrent = Torrent.find params[:torrent_id]
    @comment = @torrent.comments.find params[:id]
    @comment.destroy
    
    respond_with @torrent, @comment, :location => torrent_path(@torrent)
  end
  
  def update
    @torrent = Torrent.find params[:torrent_id]
    @comment = @torrent.comments.find params[:id]
    @comment.update_attributes(params[:comment])
    @comment.save
    
    respond_with @torrent, @comment, :location => torrent_path(@torrent)
  end
  
  def edit
    @torrent = Torrent.find params[:torrent_id]
    @comment = @torrent.comments.find(params[:id])
    respond_with @torrent, @comment
  end
  
  def new
    @torrent = Torrent.find params[:torrent_id]
    @comment = @torrent.comments.new
    respond_with @torrent, @comment
  end
end
