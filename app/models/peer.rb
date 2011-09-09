class Peer < ActiveRecord::Base
  belongs_to :torrent
  
  scope :seeders, where{left == 0}
  scope :leechers, where{left != 0}
  
  attr_accessible :peer_id,
                  :ip,
                  :port,
                  :uploaded,
                  :downloaded,
                  :left
  
  #validates :peer_id,
  #  :length => { :is => 20 }
  
  validates :ip,
    :format => { :with => /^([0-9]{1,3}).([0-9]{1,3}).([0-9]{1,3}).([0-9]{1,3})$/ }
  
  validates :port,
    :numericality => { :greater_than => 0, :less_than_or_equal_to => 65535 }
  
  validates :uploaded,
    :numericality => { :only_integer => true }
  
  validates :downloaded,
    :numericality => { :only_integer => true }
  
  validates :left,
    :numericality => { :only_integer => true }
end
