class Comment < ActiveRecord::Base
  belongs_to :torrent, :counter_cache => true
end
