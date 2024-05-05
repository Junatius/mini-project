class Chat < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: 'User'

  validates :message, presence: true
end
