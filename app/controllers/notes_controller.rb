class NotesController < ApplicationController
  respond_to :html
  
  def create
    @report = Report.find params[:report_id]
    @note = @report.notes.new params[:note]
    @note.user = current_user
    @note.save
    respond_with @report, @note, :location => report_path(@report)
  end
  
  def new
    @report = Report.find params[:report_id]
    @note = @report.notes.new
    respond_with @report, @note
  end
end
