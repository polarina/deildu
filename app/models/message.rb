class Message < ActiveRecord::Base
  default_scope reorder("created_at desc")
  
  belongs_to :parent, :class_name => "Message", :foreign_key => "parent_id"
  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  
  attr_accessible :subject,
                  :message
  
  validates :receiver,
    :presence => true,
    :associated => true
  
  validates :subject,
    :length => { :within => 5..48 }
  
  validates :message,
    :length => { :within => 5..8192 }
  
  def content
    message
  end
end
