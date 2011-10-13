class Topic < ActiveRecord::Base
  self.per_page = 10
  
  belongs_to :forum
  belongs_to :user
  has_many :posts, :dependent => :destroy
  
  attr_accessible :subject
  
  validates :subject,
    :length => { :within => 5..48 }
  
  def self.overview(current_user)
    agr_posts = Topic.joins{posts.outer}.group{id}.select{[id, count(topics.id).as(count)]}
    
    lui = Post.joins{user.outer}.where{topics.id == posts.topic_id}.select{[
      id,
      user.username.as(username),
      created_at
    ]}.order{created_at.desc}.limit(1)
    
    Topic
      .joins{user.outer}
      .joins("INNER JOIN (#{agr_posts.to_sql}) AS t1 ON t1.id = topics.id")
      .joins("LEFT OUTER JOIN read_topics AS t2 ON t2.user_id = #{current_user.id} AND t2.topic_id = (SELECT topics.id FROM (#{lui.to_sql}) AS a)")
      .select{[
        id,
        forum_id,
        subject,
        user.username.as(username),
        t1.count.as(posts_count),
        t2.post_id.as(last_post_read),
        "(SELECT id FROM (#{lui.to_sql}) AS a) AS last_post_id",
        "(SELECT username FROM (#{lui.to_sql}) AS a) AS last_username",
        "(SELECT created_at FROM (#{lui.to_sql}) AS a) AS last_created_at",
      ]}.order("last_created_at DESC NULLS LAST")
  end
end
