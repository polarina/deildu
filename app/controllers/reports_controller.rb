# encoding: utf-8

class ReportsController < ApplicationController
  respond_to :html
  
  def create
    @report = current_user.reports.new params[:report]
    @report.status_id = 1
    
    @report.victim = Comment.find params[:comment] if params[:comment]
    @report.victim = Post.find params[:post] if params[:post]
    @report.victim = Torrent.find params[:torrent] if params[:torrent]
    
    raise ActionController::RoutingError.new('Not Found') if @report.victim.nil?
    
    flash[:notice] = "Tilkynning þín hefur verið móttekin." if @report.save
    respond_with @report, :location => root_path
  end
  
  def index
    @reports = Report.all
    respond_with @reports
  end
  
  def new
    @report = Report.new
    @report.victim = Comment.find params[:comment] if params[:comment]
    @report.victim = Post.find params[:post] if params[:post]
    @report.victim = Torrent.find params[:torrent] if params[:torrent]
    
    raise ActionController::RoutingError.new('Not Found') if @report.victim.nil?
    
    respond_with @report
  end
  
  def show
    @report = Report.find params[:id]
    respond_with @report
  end
end
