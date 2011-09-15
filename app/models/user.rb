class User < ActiveRecord::Base
  include Gravtastic
  
  has_secure_password
  gravtastic :size => 150, :rating => "X"
  
  has_many :invitations
  has_many :invitees, :class_name => "User", :foreign_key => "inviter_id"
  belongs_to :inviter, :class_name => "User"
  
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
  
  validates :downloaded,
    :numericality => { :greater_than_or_equal_to => 0 }
  
  validates :uploaded,
    :numericality => { :greater_than_or_equal_to => 0 }
  
  before_create do
    self.update_passkey
  end
  
  def to_param
    self.username
  end
  
  def ratio
    self.uploaded.to_f / self.downloaded.to_f
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
end
