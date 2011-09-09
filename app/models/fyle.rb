class Fyle < ActiveRecord::Base
  scope :oby_path, order(:path)
  scope :oby_ordering, order(:ordering)
  
  belongs_to :torrent
end
