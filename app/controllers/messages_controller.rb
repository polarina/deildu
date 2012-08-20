class MessagesController < ApplicationController
  respond_to :html
  
  def create
    @message = Message.new params[:message]
    @message.sender = current_user
    @message.sender_deleted = false
    @message.receiver_deleted = false
    
    if params[:reply]
      @message.parent = Message.find params[:reply]
      @message.receiver = @message.parent.sender
    else
      @message.receiver = User.find_by_username params[:message][:receiver]
    end
    
    @message.save
    
    respond_with @message
  end
  
  def inbox
    @messages = current_user.received_messages
  end
  
  def outbox
    @messages = current_user.sent_messages
  end
  
  def new
    @message = Message.new
    @message.receiver = User.find_by_username params[:receiver]
    @reply = Message.find params[:reply] if params[:reply]
    
    if @reply
      @message.subject = "Re: " + @reply.subject
    end
  end
  
  def show
    @message = Message.find params[:id]
  end
end
