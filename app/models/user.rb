class User < ActiveRecord::Base
  include Gravtastic
  
  has_secure_password
  gravtastic :size => 150, :rating => "X"
  
  has_many :invitations
  has_many :invitees, :class_name => "User", :foreign_key => "inviter_id"
  belongs_to :inviter, :class_name => "User"
  
  has_many :bans
  has_many :blocks
  has_many :reports
  
  attr_accessible :username,
                  :password,
                  :password_confirmation,
                  :email
  
  validates :username,
    :uniqueness => true,
    :length => { :maximum => 30 },
    :format => { :with => /^([a-z0-9]+)$/i }
  
  validates :password,
    :length => { :minimum => 8 },
    :if => :password_digest_changed?
  
  validates :email,
    :uniqueness => true,
    :length => { :within => 5..320 },
    :format => { :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i }
  
  before_create do
    self.update_passkey
  end
  
  def to_param
    self.username
  end
  
  def has_permission_to?(params)
    controller, action = params[:controller], params[:action]
    action = "create" if action == "new"
    action = "update" if action == "edit"
    
    permissions = [
      {
        "blocks" => {
          "create" => Proc.new { User.find_by_username!(params[:user]) != self },
          "destroy" => true,
          "index" => true,
        },
        "comments" => {
          "create" => true,
        },
        "forums" => {
          "index" => true,
          "show" => true,
        },
        "front" => {
          "index" => true,
        },
        "invitations" => {
          "create" => true,
          "index" => true,
          "destroy" => true,
        },
        "messages" => {
          "create" => Proc.new do
            return true unless params[:reply]
            
            msg = Message.find params[:reply]
            (not msg.sender_deleted and msg.sender_id == self.id) or (not msg.receiver_deleted and msg.receiver_id == self.id)
          end,
          "inbox" => true,
          "outbox" => true,
          "show" => Proc.new do
            msg = Message.find params[:id]
            (not msg.sender_deleted and msg.sender_id == self.id) or (not msg.receiver_deleted and msg.receiver_id == self.id)
          end,
        },
        "pages" => {
          "page" => true,
        },
        "posts" => {
          "create" => true,
          "destroy" => Proc.new { Post.find(params[:id]).user == self },
        },
        "reports" => {
          "create" => true,
        },
        "topics" => {
          "create" => true,
          "destroy" => Proc.new { Topic.find(params[:id]).user == self },
          "show" => true,
        },
        "torrents" => {
          "create" => true,
          "destroy" => Proc.new { Torrent.find(params[:id]).user == self },
          "index" => true,
          "show" => true,
          "update" => Proc.new { Torrent.find(params[:id]).user == self },
        },
        "users" => {
          "auth" => true,
          "show" => true,
        },
      },
      {
        "users" => {
          "index" => true,
        },
      },
      {
        "comments" => {
          "destroy" => true,
          "update" => true,
        },
        "forums" => {
          "create" => true,
          "destroy" => true,
          "update" => true,
        },
        "notes" => {
          "create" => true,
        },
        "pages" => {
          "create" => true,
          "destroy" => true,
          "index" => true,
          "show" => true,
          "update" => true,
        },
        "posts" => {
          "delete" => true,
        },
        "reports" => {
          "index" => true,
          "show" => true,
        },
        "topics" => {
          "destroy" => true,
        },
        "torrents" => {
          "destroy" => true,
          "update" => true,
        },
        "users" => {
          "update" => true,
        },
      },
      {
        "bans" => {
          "create" => true,
          "destroy" => true,
          "index" => true,
          "show" => true,
          "update" => true,
        },
      }
    ]
    
    permissions[0..permission_level].each do |v|
      section = v[controller]
      section = section[action] if section
      section = section.call if section.class == Proc
      
      return true if section
    end
    
    false
  end
  
  def update_passkey
    self.key = SecureRandom::urlsafe_base64(16)
  end
  
  def uploaded_overview
    user = self.id
    Torrent.overview.where{user_id == user}
  end
  
  def leeching_overview
    user = self.id
    Torrent.overview.joins{peers}.where{(peers.left != 0) & (peers.user_id == user)}
  end
  
  def seeding_overview
    user = self.id
    Torrent.overview.joins{peers}.where{(peers.left == 0) & (peers.user_id == user)}
  end
  
  def received_messages
    Message.where(:receiver_id => self.id)
  end
  
  def sent_messages
    Message.where(:sender_id => self.id)
  end
end
