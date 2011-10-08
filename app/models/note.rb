class Note < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  
  attr_accessible :note
  
  validates :note,
    :length => { :within => 5..8192 }
  
  def content
    note
  end
end
