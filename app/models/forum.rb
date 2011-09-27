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
  
  def self.overview
    agr_topics = Forum.joins{topics.outer}.group{id}.select{[id, count(topics.id).as(count)]}
    agr_posts = Forum.joins{[topics.outer.posts.outer]}.group{id}.select{[id, count(posts.id).as(count)]}
    
    base = Post.where{topics.id == posts.topic_id}.order{created_at.desc}.limit(1)
    baset = Topic.where{forums.id == topics.forum_id}
    
    lui = baset.select{[id.as(ida), "(#{base.select{user_id}.to_sql}) AS user_id"]}
    lca = baset.select{[id.as(idb), "(#{base.select{created_at}.to_sql}) AS created_at"]}
    ltn = baset.select{[id.as(idc), subject.as(subject)]}
    
    def self.new_aggreg(lui, lca, ltn, offset)
      "SELECT t#{offset}.ida AS topic_id, t#{offset}.user_id AS user_id, t#{offset+1}.created_at AS created_at, t#{offset+2}.subject AS subject FROM (#{lui.to_sql}) AS t#{offset} INNER JOIN (#{lca.to_sql}) AS t#{offset+1} ON t#{offset}.ida = t#{offset+1}.idb INNER JOIN (#{ltn.to_sql}) AS t#{offset+2} ON t#{offset}.ida = t#{offset+2}.idc ORDER BY created_at DESC NULLS LAST LIMIT 1"
    end
    
    a = "(SELECT topic_id FROM (#{new_aggreg(lui, lca, ltn, 3)} ) AS a) AS last_topic_id"
    b = "(SELECT user_id FROM (#{new_aggreg(lui, lca, ltn, 5)}) AS a) AS last_user_id"
    c = "(SELECT created_at FROM (#{new_aggreg(lui, lca, ltn, 7)}) AS a) AS last_created_at"
    d = "(SELECT subject FROM (#{new_aggreg(lui, lca, ltn, 9)}) AS a) AS last_subject"
    Forum
      .joins("INNER JOIN (#{agr_topics.to_sql}) AS t1 ON t1.id = forums.id")
      .joins("INNER JOIN (#{agr_posts.to_sql}) AS t2 ON t2.id = forums.id")
      .select{[
        id,
        title,
        description,
        t1.count.as(topics_count),
        t2.count.as(posts_count),
        a,
        b,
        c,
        d
      ]}
  end
end
