class NewsController < ApplicationController
  respond_to :html
  
  def create
    @news = current_user.news.create params[:news]
    respond_with @news, :location => root_path
  end
  
  def destroy
    @news = News.find params[:id]
    @news.destroy
    respond_with @news, :location => root_path
  end
  
  def edit
    respond_with(@news = News.find(params[:id]))
  end
  
  def new
    respond_with(@news = News.new)
  end
  
  def update
    @news = News.find params[:id]
    @news.update_attributes params[:news]
    respond_with @news, :location => root_path
  end
end
