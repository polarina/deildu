# encoding: utf-8

class Markdown
  attr_accessor :id
  attr_accessor :content
end

class MarkdownsController < ApplicationController
  respond_to :html
  
  def create
    @markdown = Markdown.new
    @markdown.id = 1
    @markdown.content = params[:markdown][:content]
  end
  
  def show
  end
end
