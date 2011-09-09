class Invitation < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :email
  
  validates :user_id,
    :presence => true
  
  validates :key,
    :presence => true,
    :uniqueness => true
  
  validates :email,
    :uniqueness => { :scope => :user_id },
    :length => { :within => 5..320 },
    :format => { :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i }
  
  validate do |model|
    if User.exists?(:email => model.email)
      model.errors.add :email, "already in use"
    end
  end
  
  before_validation do
    self.key = SecureRandom::urlsafe_base64(16)
  end
  
  def to_param
    self.key
  end
end
