class User < ActiveRecord::Base
  has_secure_password
  
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
  
  def to_param
    self.username
  end
  
  def ratio
    self.uploaded.to_f / self.downloaded.to_f
  end
end
