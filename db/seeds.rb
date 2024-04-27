# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#  
# Create 5 sample users
User.create!(
  name: 'Emong Maryadi',
  email: 'emong@example.com',
  password: 'password',
  photo_url: 'https://example.com/emong.jpg'
)

User.create!(
  name: 'Genta Hastuti',
  email: 'genta@example.com',
  password: 'password',
  photo_url: 'https://example.com/genta.jpg'
)

User.create!(
  name: 'Embuh Saptono',
  email: 'embuh@example.com',
  password: 'password',
  photo_url: 'https://example.com/embuh.jpg'
)

User.create!(
  name: 'Maryam Wijaya',
  email: 'maryam@example.com',
  password: 'password',
  photo_url: 'https://example.com/maryam.jpg'
)

User.create!(
  name: 'Rudi Kusuma',
  email: 'rudi@example.com',
  password: 'password',
  photo_url: 'https://example.com/rudi.jpg'
)

puts 'Sample users created!'
