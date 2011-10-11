class FrontController < ApplicationController
  def index
    @news = News.order("created_at desc")
    @active_users = User.where{visited_at > 20.minutes.ago}.order{username.asc}.all
  end
end
