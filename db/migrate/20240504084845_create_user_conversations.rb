class CreateUserConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :user_conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :conversation, null: false, foreign_key: true
      t.integer :unread_count, default: 0

      t.timestamps
    end
    add_index :user_conversations, [:user_id, :conversation_id], unique: true
  end
end
