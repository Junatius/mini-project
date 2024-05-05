FactoryBot.define do
  factory :user_conversation do
    association :user
    association :conversation
    unread_count { 0 }
  end
end
