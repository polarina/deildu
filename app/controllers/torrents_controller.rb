# encoding: utf-8

class TorrentsController < ApplicationController
  skip_before_filter :requires_authorization, :only => :announce
  respond_to :html
  
  def create
    @torrent = Torrent.populate(params[:torrent][:torrent].read)
    @torrent.attributes = params[:torrent]
    @torrent.user_id = current_user.id
    @torrent.save
    
    respond_with @torrent
  end
  
  def update
    @torrent = Torrent.find(params[:id])
    @torrent.update_attributes(params[:torrent])
    respond_with @torrent
  end
  
  def index
    @torrents = Torrent.overview
  end
  
  def show
    @torrent = Torrent.find(params[:id])
    
    respond_to do |format|
      format.html
      format.torrent { render :text => @torrent.torrent_file.bencode }
    end
  end
  
  def new
    @torrent = Torrent.new
  end
  
  def edit
    @torrent = Torrent.find(params[:id])
  end
  
  def announce
    @torrent = Torrent.find_by_infohash params[:info_hash]
    render :text => { "failure reason" => "Torrent ekki á skrá" }.bencode and return if @torrent.nil?
    
    @peer = Peer.find_or_initialize_by_torrent_id_and_peer_id(@torrent.id, params[:peer_id])
    @peer.destroy and render :text => { }.bencode and return if params[:event] == "stopped"
    
    @peer.update_attributes(params)
    @peer.ip = request.ip if params[:ip].nil?
    @peer.user_id = 1
    
    if @peer.save
      render :text => {
        "interval" => 2.minutes.to_i,
        "min interval" => 2.seconds.to_i,
        "complete" => 0, # todo
        "incomplete" => 0, # todo
        "peers" => @torrent.peers.map{|v| {
          "peer id" => v.peer_id,
          "ip" => v.ip,
          "port" => v.port
        } }
      }.bencode
    else
      render :text => { "failure reason" => "Invalid parameters" }.bencode
    end
  end
  
  def scrape
  end
end
