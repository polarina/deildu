class CommentsController < ApplicationController
  respond_to :html
  
  def create
    @torrent = Torrent.find params[:torrent_id]
    @comment = @torrent.comments.new(params[:comment])
    
    @comment.user = current_user
    @comment.torrent = @torrent
    @comment.save
    
    respond_with @comment, :location => torrent_path(@torrent)
  end
  
  def update
    @torrent = Torrent.find params[:torrent_id]
    @comment = @torrent.comments.find params[:id]
    @comment.update_attributes(params[:comment])
    @comment.save
    
    respond_with @comment, :location => torrent_path(@torrent)
  end
  
  def edit
    @torrent = Torrent.find params[:torrent_id]
    respond_with(@comment = @torrent.comments.find(params[:id]))
  end
  
  def new
    @torrent = Torrent.find params[:torrent_id]
    respond_with(@comment = @torrent.comments.new)
  end
end
