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
  
  def content
    post
  end
  
  def self.overview
    agr_posts = Topic.joins{posts.outer}.group{id}.select{[id, count(topics.id).as(count)]}
    
    lui = Post.joins{user.outer}.where{topics.id == posts.topic_id}.select{[
      id,
      user.username.as(username),
      created_at
    ]}.order{created_at.desc}.limit(1)
    
    Topic
      .joins{user.outer}
      .joins("INNER JOIN (#{agr_posts.to_sql}) AS t1 ON t1.id = topics.id")
      .select{[
        id,
        forum_id,
        subject,
        user.username.as(username),
        t1.count.as(posts_count),
        "(SELECT username FROM (#{lui.to_sql}) AS a) AS last_username",
        "(SELECT created_at FROM (#{lui.to_sql}) AS a) AS last_created_at",
      ]}.order("last_created_at DESC NULLS LAST")
  end
end
