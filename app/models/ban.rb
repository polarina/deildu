class Ban < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :address
  
  validates :address,
    :format => { :with => // }
end
