FactoryBot.define do
  factory :chat do
    association :conversation
    association :sender, factory: :user
    message { Faker::Lorem.sentence }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
