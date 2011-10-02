class Comment < ActiveRecord::Base
  belongs_to :torrent
  belongs_to :user
  
  attr_accessible :comment
  
  validates :torrent,
    :presence => true,
    :associated => true
  
  validates :comment,
    :presence => true
  
  def content
    comment
  end
end
