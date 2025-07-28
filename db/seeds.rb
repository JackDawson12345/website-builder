# Create admin user
admin = User.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

# Create customer user
customer = User.create!(
  email: 'customer@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: false
)

puts "Created #{User.count} users"
puts "Admin: admin@example.com / password"
puts "Customer: customer@example.com / password"