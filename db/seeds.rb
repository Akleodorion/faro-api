# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'open-uri'
require 'faker'

file = URI.open('https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/NES-Console-Set.jpg/1200px-NES-Console-Set.jpg')
Event.destroy_all





60.times do
  random_id = rand(1..250)
  url = "https://api.jikan.moe/v4/manga/#{random_id}"
  begin
    json_data = URI.open(url).read
    data = JSON.parse(json_data)
    category = %w[loisir sport concert culture]
    free = [true, false]

    # upload on cloudinary
    file = URI.open(data['data']['images']['jpg']['large_image_url'])

    # event require name, description, location, category, free or not, ticket pricing ,a user and an picture url.
    saga = data['data']['titles'][0]['title']
    picture = data['data']['images']['jpg']['large_image_url']
    volume = rand(1..data['data']['volumes'].to_i)
    volume = 1 if data['data']['volumes'].nil?

    event = Event.new(name: 'Evenement 1', description: 'Une description simple et efficace qui fonctionne plutot bien',
                      date: Faker::Date.between(from: '2023-09-15', to: '2023-12-31'), location: Faker::Address.city,
                      category: category.sample, free: free.sample, max_standard_ticket: 20,
                      standard_ticket_price: (1..5).to_a.sample * 1000, max_vip_ticket: 15, vip_ticket_price: (10..15).to_a.sample * 1000,
                      max_vvip_ticket: 10, vvip_ticket_price: (20..25).to_a.sample * 1000, user: User.all.first, photo_url: picture)
    event.photo.attach(io: file, filename: "#{saga}-#{volume}.jpg", content_type: 'image/jpg')
    event.save
    sleep 1
  rescue OpenURI::HTTPError => error
    next
  end
end
