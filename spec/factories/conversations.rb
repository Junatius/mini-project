FactoryBot.define do
  factory :conversation do
    association :sender, factory: :user
    association :receiver, factory: :user
    created_at { Time.now }
    updated_at { Time.now }
  end
end
