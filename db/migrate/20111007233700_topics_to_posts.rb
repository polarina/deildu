class TopicsToPosts < ActiveRecord::Migration
  class Topic < ActiveRecord::Base
  end
  
  class Post <  ActiveRecord::Base
  end
  
  def change
    Topic.all.each do |topic|
      Post.create({
        :created_at => topic.created_at,
        :updated_at => topic.updated_at,
        :topic_id => topic.id,
        :user_id => topic.user_id,
        :post => topic.post,
      })
    end
    
    remove_column :topics, :post
  end
end
