# rubocop:disable Rails/Output
include FactoryBot::Syntax::Methods # rubocop:disable Style/MixinUsage
File.readlines('app/assets/config/film_genres.txt').each do |line|
  name = line.strip
  puts "Creating the genre #{name}".light_cyan
  Genre.create!(name:)
end

genre_ids = Genre.all.map(&:id)

JSON.parse(File.read('db/seeds.json')).each do |hsh|
  title = hsh['title']
  description = hsh['description']
  released_on = hsh['released_on']
  rating = hsh['rating']
  total_gross = hsh['total_gross']
  director = hsh['director']
  duration = hsh['duration']

  puts "TITLE: #{title}"

  Movie.create(
    title:,
    description:,
    released_on:,
    rating:,
    total_gross:,
    director:,
    duration:
  )
end

[
  ['Avengers Endgame', 'avengers-end-game.png'],
  ['Captain Marvel', 'captain-marvel.png'],
  ['Black Panther', 'black-panther.png'],
  ['Avengers: Infinity War', 'avengers-infinity-war.png'],
  ['Green Lantern', 'green-lantern.png'],
  ['Fantastic Four', 'fantastic-four.png'],
  ['Iron Man', 'ironman.png'],
  ['Superman', 'superman.png'],
  ['Spider-Man', 'spiderman.png'],
  ['Batman', 'batman.png'],
  ['Catwoman', 'catwoman.png'],
  ['Wonder Woman', 'wonder-woman.png']
].each do |movie_title, file_name|
  puts "MOVIE TITLE: #{movie_title}"
  movie = Movie.find_by!(title: movie_title)
  file = Rails.root.join("app/assets/images/#{file_name}").open
  movie.main_image.attach(io: file, filename: file_name)
end

password = 'testicles123'
test_user = User.create!(username: 'testuser', name: 'Test User', email: 'test@test.com', password:)
puts "Created #{test_user.username} for #{test_user.name}, #{test_user.email}, password: #{password}".green

admin_user = User.create!(username: 'adminuser', name: 'admin User', email: 'admin@admin.com', password:, admin: true)
puts "Created #{admin_user.username} for #{admin_user.name}, #{admin_user.email}, password: #{password}".green

20.times do
  User.create(
    name: Faker::Name.name,
    username: Faker::Internet.username,
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )
end

ad_hoc = -> { [true, false].sample }

Movie.all.each do |movie|
  movie.genre_ids = genre_ids.sample(3)
  User.all.each do |user|
    if movie.title.eql?('Wonder Woman')
      puts "Not creating reviews for #{movie.title}".light_red
    else
      next unless ad_hoc.call

      puts "Creating reviews for #{movie.title} for #{user.name}".light_yellow
      create(:review, movie:, user_id: user.id)
      next unless ad_hoc.call

      puts "#{user.name} faves #{movie.title}".light_green
      Favourite.create(movie:, user:)

    end
  end
end
# rubocop:enable Rails/Output
