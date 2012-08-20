class User < ActiveRecord::Base
  include Gravtastic
  
  self.per_page = 20
  
  has_secure_password
  gravtastic :size => 150, :rating => "X", :default => :monsterid
  
  has_many :invitations
  has_many :invitees, :class_name => "User", :foreign_key => "inviter_id"
  belongs_to :inviter, :class_name => "User"
  
  has_many :bans
  has_many :blocks
  has_many :news
  has_many :reports
  
  attr_accessible :username,
                  :password,
                  :password_confirmation,
                  :email,
                  :show_avatars
  
  validates :username,
    :uniqueness => true,
    :length => { :maximum => 30 },
    :format => { :with => /^([a-z0-9]+)$/i }
  
  validates :password,
    :length => { :minimum => 8 },
    :allow_nil => true
    #:if => :password_digest_changed?
  
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
    
    def inst(klass, something)
      if something.class == klass
        something
      else
        klass.find(something)
      end
    end
    
    permissions = [
      # Permission level 0
      {
        "blocks" => {
          "create" => Proc.new do
            user = User.find_by_username!(params[:user])
            
            user != self and not self.blocks.exists?(:blocked_id => user.id)
          end,
          "destroy" => Proc.new do
            user = User.find_by_username!(params[:id])
            
            self.blocks.exists?(:blocked_id => user.id)
          end,
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
        "markdowns" => {
          "create" => true,
          "show" => true,
        },
        "messages" => {
          "create" => Proc.new do
            next true unless params[:reply]
            
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
          "create" => Proc.new do
            topic = inst Topic, params[:topic_id]
            not topic.locked
          end,
          "destroy" => Proc.new do
            topic = inst Topic, params[:topic_id]
            post = inst Post, params[:id]
            post_topic_id = post.topic_id
            
            oldest = Post.limit(1).select{id}.where{topic_id == post_topic_id}.order{created_at.asc}
            newest = Post.limit(1).select{id}.where{topic_id == post_topic_id}.order{created_at.desc}
            
            (not topic.locked) and post.user_id == self.id and newest.first.id == post.id and oldest.first.id != post.id
          end,
          "update" => Proc.new do
            topic = inst Topic, params[:topic_id]
            (not topic.locked) and inst(Post, params[:id]).user_id == self.id
          end,
        },
        "profiles" => {
          "show" => true,
          "update" => true,
        },
        "reports" => {
          "create" => true,
        },
        "topics" => {
          "create" => true,
          "destroy" => Proc.new do
            topic = Topic.find params[:id]
            (not topic.locked) and topic.user_id == self.id and topic.posts.limit(2).count <= 1
          end,
          "show" => true,
          "update" => Proc.new do
            if params[:topic]
              next false if params[:topic][:forum]
              next false if params[:topic][:sticky]
              next false if params[:topic][:locked]
            end
            
            topic = inst(Topic, params[:id])
            (not topic.locked) and topic.user_id == self.id
          end,
        },
        "torrents" => {
          "create" => true,
          "destroy" => Proc.new do
            torrent = Torrent.find params[:id]
            torrent.user_id == self.id and torrent.created_at > 3.hours.ago
          end,
          "index" => true,
          "show" => true,
          "update" => Proc.new { Torrent.find(params[:id]).user == self },
        },
        "users" => {
          "auth" => true,
          "show" => true,
        },
      },
      # Permission level 1
      {
        "users" => {
          "index" => true,
        },
      },
      # Permission level 2
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
        "news" => {
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
          "create" => true,
          "destroy" => Proc.new do
            post = inst Post, params[:id]
            post_topic_id = post.topic_id
            
            oldest = Post.limit(1).select{id}.where{topic_id == post_topic_id}.order{created_at.asc}
            oldest.first.id != post.id
          end,
          "update" => true,
        },
        "reports" => {
          "index" => true,
          "show" => true,
        },
        "topics" => {
          "destroy" => true,
          "update" => true,
        },
        "torrents" => {
          "destroy" => true,
          "update" => true,
        },
        "users" => {
          "update" => true,
        },
      },
      # Permission level 4
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
    Torrent.overview.where{user_id == user}.order{created_at.desc}
  end
  
  def leeching_overview
    user = self.id
    Torrent.overview.joins{peers}.where{(peers.left != 0) & (peers.user_id == user)}.order{created_at.desc}
  end
  
  def seeding_overview
    user = self.id
    Torrent.overview.joins{peers}.where{(peers.left == 0) & (peers.user_id == user)}.order{created_at.desc}
  end
  
  def received_messages
    Message.where(:receiver_id => self.id)
  end
  
  def sent_messages
    Message.where(:sender_id => self.id)
  end
  
  def to_s
    self.username
  end
end
