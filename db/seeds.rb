puts "Seeding.."

users = [
  { email: "test@example.com" },
  { email: "admin@example.com", admin: true }
]

users.each do |data|
  User.find_or_initialize_by(email: data[:email]).tap do |user|
    user.admin = user[:admin]
    user.skip_confirmation!
    user.password = user.password_confirmation = "password"
  end.save
end

puts "Finished.."
