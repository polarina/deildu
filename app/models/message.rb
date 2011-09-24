class Message < ActiveRecord::Base
  default_scope reorder("created_at desc")
  
  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  
  attr_accessible :subject,
                  :message
  
  #@@receiver = nil
  
  #validate do |m|
  #  user = User.find_by_username receiver
  #  if user.nil? or not user.valid?
  #    m.errors.add(:receiver, "was not found")
  #  end
  #end
  
  validates :receiver,
    :presence => true,
    :associated => true
  
  validates :subject,
    :presence => true
  
  validates :message,
    :presence => true
end
