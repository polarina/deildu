class News < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :content
  
  validates :content,
    :length => { :within => 5..8192 }
end
