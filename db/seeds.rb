include FactoryBot::Syntax::Methods # rubocop:disable Style/MixinUsage

JSON.parse(File.read('db/seeds.json')).each do |hsh|
  title = hsh['title']
  description = hsh['description']
  released_on = hsh['released_on']
  rating = hsh['rating']
  total_gross = hsh['total_gross']
  director = hsh['director']
  duration = hsh['duration']
  image_file_name = hsh['image_file_name']

  Movie.create(
    title:,
    description:,
    released_on:,
    rating:,
    total_gross:,
    director:,
    duration:,
    image_file_name:
  )
end

# rubocop:disable Rails/Output
Movie.all.each do |movie|
  if movie.title.eql?('Wonder Woman')
    puts "Not creating reviews for #{movie.title}".light_red
  else
    puts "Creating reviews for #{movie.title}".light_yellow
    60.times { create(:review, movie:) }
  end
end
# rubocop:enable Rails/Output

password = 'testicles123'
test_user = User.create!(username: 'testuser', name: 'Test User', email: 'test@test.com', password:)
puts "Created #{test_user.username} for #{test_user.name}, #{test_user.email}, password: #{password}".green

admin_user = User.create!(username: 'adminuser', name: 'admin User', email: 'admin@admin.com', password:, admin: true)
puts "Created #{admin_user.username} for #{admin_user.name}, #{admin_user.email}, password: #{password}".green

5.times do
  User.create(
    name: Faker::Name.name,
    username: Faker::Internet.username,
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )
end
