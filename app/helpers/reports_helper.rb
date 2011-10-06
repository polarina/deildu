module ReportsHelper
  def link_report(report)
    case report.victim.class.to_s
      when "Comment" then
        link_to "comment ##{report.victim_id}", report_path(report)
      when "Post" then
        link_to "post ##{report.victim_id}", report_path(report)
      when "Torrent" then
        link_to "torrent ##{report.victim_id}", report_path(report)
    end
  end
  
  def link_victim(report)
    case report.victim.class.to_s
      when "Comment" then
        link_to "comment ##{report.victim_id}", torrent_path(report.victim.torrent_id, :anchor => "comment" + report.victim_id.to_s)
      when "Post" then
        link_to "post ##{report.victim_id}", forum_topic_path(report.victim.topic.forum_id, report.victim.topic_id, :anchor => "post" + report.victim_id.to_s)
      when "Torrent" then
        link_to "torrent ##{report.victim_id}", torrent_path(report.id)
    end
  end
  
  def render_victim(victim)
    case victim.class.to_s
      when "Comment" then
        message :user => victim.user, :created_at => victim.created_at, :content => victim
      when "Post" then
        message :user => victim.user, :created_at => victim.created_at, :content => victim
      when "Torrent" then
        nil
    end
  end
end