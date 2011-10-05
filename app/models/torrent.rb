class Torrent < ActiveRecord::Base
  has_many :comments
  has_many :fyles
  has_many :peers
  
  belongs_to :category
  belongs_to :user
  
  attr_accessible :title,
                  :anonymous,
                  :description,
                  :category_id
  
  accepts_nested_attributes_for :fyles
  
  validates :title,
    :length => { :within => 5..128 }
  
  validates :description,
    :presence => true,
    :length => { :maximum => 65535 }
  
  validates :user_id,
    :presence => true
  
  validates :category,
    :associated => true
  
  def infohash_hex
    self.infohash.unpack('H*')[0]
  end
  
  def recalculate_infohash
    user = User.new
    user.username = "stargate"
    user.key = "sg-1"
    self.infohash = Digest::SHA1.digest(self.torrent_file(user)[:info].bencode)
  end
  
  def torrent_file(user)
    if self.fyles.blank?
      info = { "length" => self.size }
    else
      info = {
        "files" => self.fyles.sort{|x, y| x.ordering <=> y.ordering}.map{|v| {
          "length" => v.size,
          "path" => v.path.split("/")
        } }
      }
    end
    
    if self.id.nil?
      key = "a"
    else
      key = {:torrent => Encryptor.encrypt(self.id.to_s, :key => user.key), :user => user.username}.bencode
    end
    
    {
      :announce => Rails.application.routes.url_helpers.announce_url(:host => "ror.system.is", :passkey => Base64::urlsafe_encode64(key)),
      :info => {
        "name" => self.info_name,
        "piece length" => self.info_piece_length,
        "pieces" => self.info_pieces,
        "private" => 1,
        "I'm sorry, Dave. I'm afraid I can't do that." => 1,
      }.merge(info)
    }
  end
  
  def self.populate(data)
    hash = BEncode.load data
    
    files = [ ]
    size = 0
    
    unless hash["info"]["files"].nil?
      hash["info"]["files"].each_with_index do |v, i|
        files << {
          :ordering => i,
          :size => v["length"].to_i,
          :path => v["path"].join("/")
        }
        
        size += v["length"].to_i
      end
    else
      size = hash["info"]["length"].to_i
    end
    
    torrent = Torrent.new
    torrent.size = size
    torrent.info_name = hash["info"]["name"]
    torrent.info_piece_length = hash["info"]["piece length"]
    torrent.info_pieces = hash["info"]["pieces"]
    torrent.fyles_attributes = files
    torrent.infohash = Digest::SHA1.digest(torrent.torrent_file(User.new)[:info].bencode)
    
    torrent
  end
  
  def self.overview
    agr_fyles = Torrent.joins{fyles.outer}.group{id}.select{[id, count(fyles.id).as(count)]}
    agr_comments = Torrent.joins{comments.outer}.group{id}.select{[id, count(comments.id).as(count)]}
    agr_leechers = Torrent.joins("LEFT OUTER JOIN peers ON torrents.id = peers.torrent_id AND peers.left != 0").group{id}.select{[id, count(peers.id).as(count)]}
    agr_seeders = Torrent.joins("LEFT OUTER JOIN peers ON torrents.id = peers.torrent_id AND peers.left = 0").group{id}.select{[id, count(peers.id).as(count)]}
    
    Torrent
      .joins{[category, user]}
      .joins("INNER JOIN (#{agr_fyles.to_sql}) AS t1 ON t1.id = torrents.id")
      .joins("INNER JOIN (#{agr_comments.to_sql}) AS t2 ON t2.id = torrents.id")
      .joins("INNER JOIN (#{agr_leechers.to_sql}) AS t3 ON t3.id = torrents.id")
      .joins("INNER JOIN (#{agr_seeders.to_sql}) AS t4 ON t4.id = torrents.id")
      .select{[
        id,
        category.id.as(category_id),
        category.title.as(category_title),
        title,
        t1.count.as(fyles_count),
        t2.count.as(comments_count),
        created_at,
        size,
        t4.count.as(seeders_count),
        t3.count.as(leechers_count),
        anonymous,
        user.username.as(username)
      ]}.order{created_at.desc}
  end
end
