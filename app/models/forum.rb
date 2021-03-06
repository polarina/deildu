class Forum < ActiveRecord::Base
  has_many :topics, :dependent => :destroy
  
  attr_accessible :ordering,
                  :title,
                  :description
  
  validates :ordering,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than => 1000000 },
    :uniqueness => true
  
  validates :title,
    :presence => true
  
  validates :description,
    :presence => true
  
  def self.overview(current_user)
    agr_topics = Forum.joins{topics.outer}.group{id}.select{[id, count(topics.id).as(count)]}
    agr_posts = Forum.joins{[topics.outer.posts.outer]}.group{id}.select{[id, count(posts.id).as(count)]}
    
    base = Post.where{topics.id == posts.topic_id}.order{created_at.desc}.limit(1)
    baset = Topic.where{forums.id == topics.forum_id}
    
    lui = baset.select{[
      id.as(topic_id),
      subject.as(subject),
      "(#{base.select{id}.to_sql}) AS post_id",
      "(#{base.select{user_id}.to_sql}) AS user_id",
      "(#{base.joins{user}.select{user.username}.to_sql}) AS username",
      "(#{base.select{created_at}.to_sql}) AS created_at"
    ]}.order("created_at DESC NULLS LAST").limit(1)
    
    Forum
      .joins("INNER JOIN (#{agr_topics.to_sql}) AS t1 ON t1.id = forums.id")
      .joins("INNER JOIN (#{agr_posts.to_sql}) AS t2 ON t2.id = forums.id")
      .joins("LEFT OUTER JOIN read_topics AS t3 ON t3.user_id = #{current_user.id} AND t3.topic_id = (SELECT topic_id FROM (#{lui.to_sql}) AS a)")
      .select{[
        id,
        title,
        description,
        t1.count.as(topics_count),
        t2.count.as(posts_count),
        t3.post_id.as(last_post_read),
        "(SELECT topic_id FROM (#{lui.to_sql}) AS a) AS last_topic_id",
        "(SELECT post_id FROM (#{lui.to_sql}) AS a) AS last_post_id",
        "(SELECT username FROM (#{lui.to_sql}) AS a) AS last_username",
        "(SELECT created_at FROM (#{lui.to_sql}) AS a) AS last_created_at",
        "(SELECT subject FROM (#{lui.to_sql}) AS a) AS last_subject"
      ]}.order{ordering.asc}
  end
end
