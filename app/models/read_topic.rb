class ReadTopic < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  belongs_to :post
end
