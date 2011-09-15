class CommentsController < ApplicationController
  respond_to :html
  
  def create
    @torrent = Torrent.find params[:torrent_id]
    @comment = Comment.new(params[:comment])
    
    @comment.user = current_user
    @comment.torrent = @torrent
    @comment.save
    
    respond_with @comment, :location => torrent_path(@torrent)
  end
  
  def edit
  end
  
  def new
    @torrent = Torrent.find params[:torrent_id]
    respond_with(@comment = Comment.new)
  end
end
