puts "Seeding.."

users = [
  { email: "test@example.com" },
  { email: "admin@example.com", admin: true }
].map do |data|
  User.find_or_initialize_by(email: data[:email]).tap do |user|
    user.admin = data.fetch(:admin, false)
    user.skip_confirmation!
    user.password = user.password_confirmation = "password"
  end.save
end

portal = users[0].portals.find_or_create_by(title: "Test Portal")
portal.destinations.find_or_create_by(url: "non-existant-url")
portal.destinations.find_or_create_by(url: "http://non-existant-url.com")
1.times do
  response = HTTParty.post "http://requestb.in/api/v1/bins"
  url = "http://requestb.in/#{JSON.parse(response.body)["name"]}"
  portal.destinations.find_or_create_by(url: url)
end

portal = users[0].portals.find_or_create_by(title: "Another Portal")
5.times do
  response = HTTParty.post "http://requestb.in/api/v1/bins"
  url = "http://requestb.in/#{JSON.parse(response.body)["name"]}"
  portal.destinations.find_or_create_by(url: url)
end

puts "Finished.."
