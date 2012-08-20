class Block < ActiveRecord::Base
  belongs_to :user
  belongs_to :blocked, :class_name => "User", :foreign_key => "blocked_id"
  
  validates_uniqueness_of :blocked_id, :scope => :user_id
  
  def to_param
    blocked.username
  end
end
