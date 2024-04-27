class User < ApplicationRecord
  has_many :sent_chats, class_name: 'Chat', foreign_key: 'sender_id', dependent: :destroy
  has_many :conversations_as_sender, class_name: 'Conversation', foreign_key: 'sender_id', dependent: :destroy
  has_many :conversations_as_receiver, class_name: 'Conversation', foreign_key: 'receiver_id', dependent: :destroy

  def conversations
    Conversation.where(id: conversations_as_sender.pluck(:id) + conversations_as_receiver.pluck(:id))
  end

  # encrypt password
  has_secure_password
end
