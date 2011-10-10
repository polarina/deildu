# encoding: utf-8

module ApplicationHelper
  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    find_and_preserve(Redcarpet.new(text, *options).to_html)
  end
  
  def link(controller, action, params = { }, &block)
    if current_user.has_permission_to?({:controller => controller.to_s, :action => action.to_s}.merge(params))
      block.call
    end
  end
  
  def pretty_kredits(kredits)
    if kredits < 0
      "-" + number_to_human_size(kredits.abs)
    else
      number_to_human_size(kredits)
    end
  end
  
  def gravatar_image(user, params = { })
    image_tag(user.gravatar_url, params.merge(:alt => "", :width => 150, :height => 150))
  end
  
  def message(options, &block)
    user = options[:user]
    created_at = options[:created_at]
    content = options[:content]
    avatar = options[:avatar]
    avatar = false unless current_user.show_avatars
    
    haml_tag :div, :class => :message do
      haml_tag :a, :name => content.class.to_s.downcase + content.id.to_s
      
      haml_tag :div, :class => :head do
        haml_tag :ul, :class => :controls do yield end if block
        
        haml_tag :ul do
          haml_tag :li, link_to(user.username, user)
          haml_tag :li, created_at
        end
      end
      
      haml_tag :div, gravatar_image(user), :class => :avatar unless avatar == false
      haml_tag :div, markdown(content.content), :class => (avatar == false ? [:markdown, :avatarless] : [:markdown])
      haml_tag :div, :class => :clear
    end
  end
  
  def torrent_overview(torrents, options = { })
    c = 0
    
    haml_tag :table do
      haml_tag :thead do
        c += 1 and haml_tag :th, "Flokkur", :class => :center
        c += 1 and haml_tag :th, "Nafn", :class => :expand
        c += 1 and haml_tag :th, "DL" unless options[:download] == false
        c += 1 and haml_tag :th, "Skrár"
        c += 1 and haml_tag :th, "Ath."
        c += 1 and haml_tag :th, "Sent Inn", :class => :nowrap unless options[:created_at] == false
        c += 1 and haml_tag :th, "Stærð"
        c += 1 and haml_tag :th, "Sótt"
        c += 1 and haml_tag :th, image_tag("arrow_up.png", :alt => "Deilendur")
        c += 1 and haml_tag :th, image_tag("arrow_down.png", :alt => "Skráarsugur")
        c += 1 and haml_tag :th, "Sent Inn Af", :class => :nowrap unless options[:user] == false
      end
      
      haml_tag :tbody do
        last_torrent = nil
        
        torrents.each do |t|
          category = Category.new
          category.id = t.category_id
          
          if options[:show_created_header] and (last_torrent.nil? or last_torrent.created_at.to_date != t.created_at.to_date)
            haml_tag :tr do
              haml_tag :th, "Sent inn #{t.created_at.to_date}", :colspan => c
            end
            
            last_torrent = t
          end
          
          haml_tag :tr do
            haml_tag :td, image_tag(category.image_path, :size => category.image_size, :alt => t.category_title), :class => :nopad
            haml_tag :td, link_to(t.title, t)
            haml_tag :td, link_to(image_tag("download.png", :alt => "Download"), torrent_path(t, :format => :torrent)) unless options[:download] == false
            haml_tag :td, (t.fyles_count.to_i == 0 ? 1 : t.fyles_count)
            haml_tag :td, t.comments_count
            haml_tag :td, t.created_at, :class => :nowrap unless options[:created_at] == false
            haml_tag :td, number_to_human_size(t.size), :class => :nowrap
            haml_tag :td, "?"
            haml_tag :td, t.seeders_count
            haml_tag :td, t.leechers_count
            
            unless options[:user] == false
              if t.anonymous
                haml_tag :td, "Nafnlaust", :class => :italic
              else
                haml_tag :td, link_to(t.username, user_path(t.username))
              end
            end
          end
        end
        
        if torrents.empty? and not options[:empty_message].nil?
          haml_tag :tr do
            haml_tag :td, options[:empty_message], :colspan => c, :class => :notice
          end
        end
      end
    end
  end
end
