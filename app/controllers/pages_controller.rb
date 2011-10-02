class PagesController < ApplicationController
  skip_before_filter :requires_authentication, :only => :page
  
  respond_to :html
  
  def create
    respond_with(@page = Page.create(params[:page]))
  end
  
  def index
    respond_with(@pages = Page.ordered.all)
  end
  
  def new
    respond_with(@page = Page.new)
  end
  
  def show
    respond_with(@page = Page.find(params[:id]))
  end
  
  def edit
    respond_with(@page = Page.find(params[:id]))
  end
  
  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
    respond_with @page
  end
  
  def page
    params[:id] = params[:section] if params[:id].blank?
    @page = Page.find_by_section_and_uri!(params[:section], params[:id])
  end
end
