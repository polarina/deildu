class Report < ActiveRecord::Base
  has_many :notes
  belongs_to :user
  belongs_to :status
  
  belongs_to :victim, :polymorphic => true
  
  attr_accessible :reason
  
  validates :reason,
    :presence => true
end
