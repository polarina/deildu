class MessagesController < ApplicationController
  respond_to :html
  
  def create
    @message = Message.new params[:message]
    @message.sender = current_user
    @message.receiver = User.find_by_username params[:message][:receiver]
    @message.sender_deleted = false
    @message.receiver_deleted = false
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
  end
  
  def show
    @message = Message.find params[:id]
  end
end
