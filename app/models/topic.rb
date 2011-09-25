class Topic < ActiveRecord::Base
  belongs_to :forum
  belongs_to :user
  has_many :posts, :dependent => :destroy
  
  attr_accessible :subject,
                  :post
  
  validates :subject,
    :presence => true
  
  validates :post,
    :presence => true
end
