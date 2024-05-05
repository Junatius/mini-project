FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password 'foobar'
    photo_url 'https://picsum.photos/200'
  end
end
