class Comment < ActiveRecord::Base
  belongs_to :torrent
  belongs_to :user
  
  attr_accessible :comment
  
  validates :torrent,
    :presence => true,
    :associated => true
  
  validates :comment,
    :length => { :within => 5..8192 }
  
  def content
    comment
  end
end
