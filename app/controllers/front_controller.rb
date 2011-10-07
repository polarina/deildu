class FrontController < ApplicationController
  def index
    @news = News.order("created_at desc")
  end
end
