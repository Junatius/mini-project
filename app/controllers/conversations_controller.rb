class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show]

  # GET /conversations
  def index
    @conversations = current_user.conversations.map do |conversation|
      {
        id: conversation.id,
        with_user: {
          id: conversation.receiver.id,
          name: conversation.receiver.name,
          photo_url: conversation.receiver.photo_url
        },
        last_message: conversation.chats.last ? {
          id: conversation.chats.last.id,
          sender: {
            id: conversation.chats.last.sender.id,
            name: conversation.chats.last.sender.name
          },
          sent_at: conversation.chats.last.created_at.to_s
        } : nil,
        unread_count: conversation.user_conversations.find_by(user: current_user).unread_count
      }
    end
    json_response(@conversations)
  end


  # GET /conversations/:id
  def show
    json_response(format_conversation(@conversation))
  end

  private

  def format_conversation(conversation)
    {
      id: conversation.id,
      with_user: format_user(conversation.receiver)
    }
  end

  def format_user(user)
    {
      id: user.id,
      name: user.name,
      photo_url: user.photo_url
    }
  end

  def set_conversation
    @conversation = Conversation.find(params[:id])
    authorize_user!
  end

  def authorize_user!
    unless @conversation.sender == current_user || @conversation.receiver == current_user
      render json: { error: Message.forbidden }, status: :forbidden
    end
  end
end
