# encoding: utf-8

#  %table
#    %thead
#      %th Lesið
#      %th.expand Spjallþráður
#      %th Póstar
#      %th Höfundur
#      %th.nowrap Síðasta innleg
#    %tbody
#      - @topics.each do |topic|
#        %tr
#          %td= topic.last_post_read == topic.last_post_id ? "Já" : "Nei"
#          %td= link_to topic.subject, forum_topic_path(@forum, topic)
#          %td= topic.posts_count
#          %td= link_to topic.username, user_path(topic.username)
#          %td.nowrap
#            - if topic.last_username
#              Eftir
#              = link_to topic.last_username, user_path(topic.last_username)
#              %br
#              = topic.last_created_at.to_time
#            - else
#              Engir póstar.
#      - if @topics.empty?
#        %tr
#          %td.notice{:colspan => 5} Engir spjallþræðir.

module ForumsHelper
  def forums_overview(topics, options = {})
    haml_tag :table do
      haml_tag :thead do
        haml_tag :th, "Lesið"
        haml_tag :th, "Spjallþráður", :class => :expand
        haml_tag :th, "Póstar"
        haml_tag :th, "Höfundur"
        haml_tag :th, "Síðasta innleg", :class => :nowrap
      end
      
      haml_tag :tbody do
        topics.each do |topic|
          haml_tag :tr do
            haml_tag :td do
              haml_concat (topic.last_post_read == topic.last_post_id ? "Já" : "Nei")
              haml_concat ", læst" if topic.locked
            end
            
            haml_tag :td, (link_to topic.subject, forum_topic_path(@forum, topic))
            haml_tag :td, topic.posts_count
            haml_tag :td, (link_to topic.username, user_path(topic.username))
            
            if topic.last_username
              haml_tag :td, :class => :nowrap do
                haml_concat "Eftir #{link_to topic.last_username, user_path(topic.last_username)}<br>#{topic.last_created_at.to_time}"
              end
            else
              haml_tag :td, "Engir póstar.", :class => :nowrap
            end
          end
        end
      end
    end
  end
end
