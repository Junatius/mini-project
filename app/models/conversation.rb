class Conversation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :chats, dependent: :destroy
  has_many :user_conversations

  def last_message
    chats.order(created_at: :desc).first
  end
end
