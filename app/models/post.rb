class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  
  attr_accessible :post
  
  validates :post,
    :length => { :within => 5..8192 }
  
  def content
    post
  end
end
