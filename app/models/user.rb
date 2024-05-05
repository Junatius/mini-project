class User < ApplicationRecord
  has_many :sent_conversations, class_name: 'Conversation', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'receiver_id', dependent: :destroy
  has_many :sent_chats, class_name: 'Chat', foreign_key: 'sender_id', dependent: :destroy
  has_many :user_conversations

  def conversations
    Conversation.where("sender_id = ? OR receiver_id = ?", self.id, self.id)
  end

  # encrypt password
  has_secure_password
end
