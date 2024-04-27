class ChatsController < ApplicationController
  before_action :authorize_request
  before_action :set_conversation, only: [:index, :create]

  def index
    messages = @conversation.chats.order(created_at: :asc)
    json_response(messages.map { |message| format_message(message) })
  end

  def create
    puts "Params: #{@current_user.id}"

    chat = @conversation.chats.new(chat_params)
    chat.sender_id = @current_user.id
    chat.receiver_id = params[:user_id]

    if chat.save
      json_response(format_message(chat), status: :created)
    else
      puts "Chat errors: #{chat.errors.inspect}"
      render json: { error: Message.invalid_attributes(chat.errors) }, status: :unprocessable_entity
    end
  end


  private

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
    render json: { error: Message.unauthorized }, status: :unauthorized unless @current_user
  end

  def chat_params
    params.require(:chat).permit(:message, :user_id)
  end

  def create_conversation(conversation_id)
    sender_id = @current_user.id
    receiver_id = params[:receiver_id]

    # Create the conversation
    conversation = Conversation.create(id: conversation_id, sender_id: sender_id, receiver_id: receiver_id)

    # Ensure the conversation is saved successfully
    unless conversation.persisted?
      render json: { error: "Failed to create conversation" }, status: :unprocessable_entity
    end

    conversation
  end

  def set_conversation
    conversation_id = params[:conversation_id]
    @conversation = Conversation.find_by(id: conversation_id)

    # If conversation does not exist, create it
    @conversation ||= create_conversation(conversation_id)

    # Ensure user can access the conversation
    ensure_user_can_access_conversation
  end

  def ensure_user_can_access_conversation
    unless current_user_can_access_conversation?(@conversation)
      render json: { error: Message.unauthorized }, status: :forbidden
    end
  end

  def current_user_can_access_conversation?(conversation)
    conversation.sender == @current_user || conversation.receiver == @current_user
  end

  def format_message(message)
    {
      id: message.id,
      message: message.message,
      sender: {
        id: message.sender.id,
        name: message.sender.name
      },
      sent_at: message.created_at
    }
  end
end
