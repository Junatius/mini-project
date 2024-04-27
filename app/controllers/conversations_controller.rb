class ConversationsController < ApplicationController
  before_action :authorize_request
  before_action :set_conversation, only: [:show]

  def index
    conversations = @current_user.conversations.includes(:chats).map { |conv| format_conversation(conv) }
    json_response(conversations)
  end


  def show
    if current_user_can_access_conversation?
      json_response(format_conversation(@conversation))
    else
      render json: { error: Message.forbidden }, status: :forbidden
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: Message.not_found('Conversation') }, status: :not_found
  end

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
    render json: { error: Message.unauthorized }, status: :unauthorized unless @current_user
  end

  def current_user_can_access_conversation?
    @conversation.sender == @current_user || @conversation.receiver == @current_user
  end

  def format_conversation(conversation)
    formatted_conversation = {
      id: conversation.id,
      with_user: format_user(conversation.sender == @current_user ? conversation.receiver : conversation.sender),
      unread_count: conversation.unread_count
    }

    last_chat = conversation.chats.last
    formatted_conversation[:last_message] = format_last_message(last_chat) if last_chat

    formatted_conversation
  end

  def format_last_message(conversation)
    last_chat = conversation.chats.last
    return unless last_chat

    {
      id: last_chat.id,
      sender: format_user(last_chat.sender),
      sent_at: last_chat.created_at
    }
  end

  def format_user(user)
    {
      id: user.id,
      name: user.name,
      photo_url: user.photo_url
    }
  end

end
