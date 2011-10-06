# encoding: utf-8

class TrackerError < StandardError
end

class TorrentsController < ApplicationController
  skip_before_filter :requires_authentication, :only => [:announce, :scrape]
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
    @comments = Comment.includes(:user).order("created_at desc").find_all_by_torrent_id(@torrent.id)
    
    respond_to do |format|
      format.html
      format.torrent { render :text => @torrent.torrent_file(current_user, request.host).bencode }
    end
  end
  
  def new
    @torrent = Torrent.new
  end
  
  def edit
    @torrent = Torrent.find(params[:id])
  end
  
  def announce
    key = process_passkey
    
    @peer = Peer.find_or_initialize_by_torrent_id_and_peer_id key.torrent.id, params[:peer_id]
    @peer.destroy and render :text => { }.bencode and return if params[:event] == "stopped"
    
    @peer.update_attributes params
    @peer.ip = request.ip if params[:ip].nil?
    @peer.user = key.user
    
    if @peer.save
      render :text => {
        "interval" => 2.minutes.to_i,
        "min interval" => 2.seconds.to_i,
        "complete" => 0, # todo
        "incomplete" => 0, # todo
        "peers" => key.torrent.peers.map{|v| {
          "peer id" => v.peer_id,
          "ip" => v.ip,
          "port" => v.port
        } }
      }.bencode
    else
      raise TrackerError, "invalid parameters"
    end
  rescue TrackerError => e
    render :text => { "failure reason" => e.to_s }.bencode
  end
  
  def scrape
    key = process_passkey
    
    render :text => {
      "files" => {
        key.torrent.infohash => {
          "complete" => key.torrent.peers.seeders.count,
          "downloaded" => 0, #todo
          "incomplete" => key.torrent.peers.leechers.count,
          "name" => key.torrent.info_name
        }
      },
      "flags" => {
        "min_request_interval" => 5.minutes.to_i
      }
    }.bencode
  rescue TrackerError => e
    render :text => { "failure reason" => e.to_s }.bencode
  end
  
  private
  
  def process_passkey
    raise TrackerError, "invalid parameters" if params[:passkey].nil? or params[:info_hash].nil?
    
    key = BEncode.load(Base64::urlsafe_decode64 params[:passkey]) rescue raise(TrackerError, "passkey rejected")
    raise TrackerError, "passkey rejected" if key["user"].nil? or key["torrent"].nil?
    
    user = User.find_by_username! key["user"] rescue raise(TrackerError, "user not found")
    raise TrackerError, "user is forbidden" unless user.allowed
    
    torrent_id = Encryptor.decrypt key["torrent"], :key => user.key rescue raise(TrackerError, "passkey rejected")
    torrent = Torrent.find torrent_id rescue raise(TrackerError, "torrent not found")
    
    raise TrackerError, "torrent not found" if torrent.infohash.bytes.to_a != params[:info_hash].bytes.to_a
    
    struct = Struct.new(:torrent, :user).new
    struct.user = user
    struct.torrent = torrent
    struct
  end
end
