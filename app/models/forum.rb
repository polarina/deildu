class Forum < ActiveRecord::Base
  has_many :topics, :dependent => :destroy
  
  attr_accessible :ordering,
                  :title,
                  :description
  
  validates :ordering,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than => 1000000 },
    :uniqueness => true
  
  validates :title,
    :presence => true
  
  validates :description,
    :presence => true
end
