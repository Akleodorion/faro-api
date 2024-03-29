# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all
User.create(email: 'test1@gmail.com', password: '1234567', username: 'Chris', phone_number: '+2250807090294')
User.create(email: 'test2@gmail.com', password: '1234567', username: 'Tressy', phone_number: '+2250807260193')
User.create(email: 'test3@gmail.com', password: '1234567', username: 'Aby', phone_number: '+2250807051023')
User.create(email: 'test4@gmail.com', password: '1234567', username: 'Elie', phone_number: '+2250807020722')

16.times do
  email = "#{Faker::Name.first_name}.#{Faker::Name.last_name}@gmail.com"
  password = Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3).to_s
  username = Faker::Ancient.primordial
  phone_number = "+22508#{Faker::PhoneNumber.subscriber_number(length: 8)}"
  User.create(email:, password:, username:, phone_number:)
end

users = User.all
number = 0
users.each do |user|
  3.times do
    random_id = rand(1..400)
    url = "https://api.jikan.moe/v4/manga/#{random_id}"
    number += 1
    begin
      # Call API.
      json_data = URI.open(url).read
      data = JSON.parse(json_data)

      # Initialisation des variables
      category = %w[loisir sport concert culture].sample
      free = [true, false].sample
      description = Faker::Lorem.paragraph(sentence_count: 15, supplemental: false, random_sentences_to_add: 10)
      date = Faker::Date.between(from: '2024-2-15', to: '2024-5-31')

      country_code = Faker::Address.country_code
      country = Faker::Address.country_by_code(code: country_code)
      locality =  Faker::Address.city
      sublocality = Faker::Address.community
      road = Faker::Address.street_address
      plus_code = Faker::Address.postcode
      latitude = Faker::Address.latitude
      longitude = Faker::Address.longitude

      standard_ticket_price = nil
      standard_ticket_description = Faker::Lorem.paragraph(sentence_count: 3)
      max_standard_ticket = rand(15..20)
      max_gold_ticket = nil
      gold_ticket_description = nil
      gold_ticket_price = nil
      platinum_ticket_description = nil
      platinum_ticket_price = nil
      max_platinum_ticket = nil
      start_time = ['18:00', '19:00', '20:00', '21:00'].sample
      end_time = ['02:00', '03:00', '04:00', '05:00'].sample

      unless free
        standard_ticket_price = rand(1..5) * 1000
        max_gold_ticket = rand(10..15)
        gold_ticket_description = Faker::Lorem.paragraph(sentence_count: 3)
        gold_ticket_price = rand(10..15) * 1000
        platinum_ticket_description = Faker::Lorem.paragraph(sentence_count: 3)
        platinum_ticket_price = rand(20..25) * 1000
        max_platinum_ticket = rand(5..10)
      end
      # upload on cloudinary
      file = URI.open(data['data']['images']['jpg']['large_image_url'])

      # event require name, description, location, category, free or not, ticket pricing ,a user and an picture url.
      saga = data['data']['titles'][0]['title']
      picture = data['data']['images']['jpg']['large_image_url']
      volume = rand(1..data['data']['volumes'].to_i)
      volume = 1 if data['data']['volumes'].nil?
      puts 'creating event'
      event = Event.new(name: "Evenement #{number}", description:, date:, country:, country_code:, category:, free:,
                        latitude:, longitude:, locality:, sublocality:, road:, plus_code:,
                        max_standard_ticket:, standard_ticket_price:, standard_ticket_description:, max_gold_ticket:,
                        gold_ticket_price:, gold_ticket_description:, max_platinum_ticket:, platinum_ticket_price:,
                        platinum_ticket_description:, user:, photo_url: picture, start_time:, end_time:,
                        activated: false, closed: false)

      event.photo.attach(io: file, filename: "#{saga}-#{volume}.jpg", content_type: 'image/jpg')
      event.save!
      puts 'saved event'
      event.update(photo_url: event.photo.blob.url)
      puts 'update event'

      sleep 1
    rescue OpenURI::HTTPError => error
      next
    end
  end
end

users.each do |user|
  events = Event.where.not(user_id: user.id)
  user_list = User.where.not(id: user.id);
  3.times do
    event = events.sample
    type = %w[standard gold platinum].sample
    if event.free
      type = 'standard'
    end
    picked_user = user_list.sample
    Member.create(event_id: event.id, user_id: picked_user.id, username: picked_user.username)
    case type
    when 'standard'
      ticket = Ticket.create(type:, description: event.standard_ticket_description,
                             price: event.standard_ticket_price, verified: [true, false].sample,
                             user_id: user.id, event_id: event.id)

      # Logique pour générer le QR code (utilisez rqrcode ou une autre bibliothèque)
      qrcode = RQRCode::QRCode.new("#{ticket.id},#{ticket.event_id},#{ticket.type}")
      png = qrcode.as_png(size: 120)

      # Enregistrez l'image temporaire
      temp_file = Tempfile.new(['qr_code', '.png'])
      temp_file.binmode
      temp_file.write(png.to_s)
      temp_file.rewind

      # Attachez le fichier à l'instance du Ticket
      ticket.photo.attach(io: temp_file, filename: 'qr_code.png')

      temp_file.close
      temp_file.unlink
      ticket.update(qr_code_url: ticket.photo.blob.url)
    when 'gold'
      ticket = Ticket.create(type:, description: event.gold_ticket_description,
                             price: event.gold_ticket_price, verified: [true, false].sample,
                             user_id: user.id, event_id: event.id)

      # Logique pour générer le QR code (utilisez rqrcode ou une autre bibliothèque)
      qrcode = RQRCode::QRCode.new("#{ticket.id},#{ticket.event_id},#{ticket.type}")
      png = qrcode.as_png(size: 120)
      # Enregistrez l'image temporaire
      temp_file = Tempfile.new(['qr_code', '.png'])
      temp_file.binmode
      temp_file.write(png.to_s)
      temp_file.rewind
      # Attachez le fichier à l'instance du Ticket
      ticket.photo.attach(io: temp_file, filename: 'qr_code.png')
      temp_file.close
      temp_file.unlink
      ticket.update(qr_code_url: ticket.photo.blob.url)
    else
      ticket = Ticket.create(type:, description: event.platinum_ticket_description,
                             price: event.platinum_ticket_price, verified: [true, false].sample,
                             user_id: user.id, event_id: event.id)

      # Logique pour générer le QR code (utilisez rqrcode ou une autre bibliothèque)
      qrcode = RQRCode::QRCode.new("#{ticket.id},#{ticket.event_id},#{ticket.type}")
      png = qrcode.as_png(size: 120)
      # Enregistrez l'image temporaire
      temp_file = Tempfile.new(['qr_code', '.png'])
      temp_file.binmode
      temp_file.write(png.to_s)
      temp_file.rewind
      # Attachez le fichier à l'instance du Ticket
      ticket.photo.attach(io: temp_file, filename: 'qr_code.png')
      temp_file.close
      temp_file.unlink
      ticket.update(qr_code_url: ticket.photo.blob.url)
    end
  end
end
