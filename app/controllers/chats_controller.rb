class ChatsController < ApplicationController
  before_action :set_conversation, only: [:index]
  before_action :authorize_user!, only: [:index]

  # GET /conversations/:conversation_id/messages
  def index
    @chats = @conversation.chats.map do |chat|
      {
        id: chat.id,
        message: chat.message,
        sender: {
          id: chat.sender.id,
          name: chat.sender.name
        },
        sent_at: chat.created_at.to_s
      }
    end
    json_response(@chats)
  end

  # POST /messages
  def create
    # Find the receiver
    receiver = User.find(params[:user_id])

    # Find or create the conversation
    @conversation = Conversation.where(sender: current_user, receiver: receiver)
                                .or(Conversation.where(sender: receiver, receiver: current_user))
                                .first_or_create

    @chat = @conversation.chats.build(chat_params)
    @chat.sender = current_user

    if @chat.save
      response = {
        id: @chat.id,
        message: @chat.message,
        sender: {
          id: @chat.sender.id,
          name: @chat.sender.name
        },
        sent_at: @chat.created_at.to_s,
        conversation: {
          id: @conversation.id,
          with_user: {
            id: receiver.id,
            name: receiver.name,
            photo_url: receiver.photo_url
          }
        }
    }
      json_response(response, :created)
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end


  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def authorize_user!
    unless @conversation.sender == current_user || @conversation.receiver == current_user
      render json: { error: Message.forbidden }, status: :forbidden
    end
  end

  def chat_params
    params.require(:chat).permit(:message, :user_id)
  end
end
