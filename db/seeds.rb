# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name: "Admin User",
             email: "admin@localhost.nul",
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             password: "admin123",
             password_confirmation: "admin123")

#99.times do |n|
#  name=Faker::Name.name
#  email="examle-#{n+1}@railstutorial.org"
#  password="password"
#  User.create!(name: name,
#               email: email,
#               password: password,
#               password_confirmation: password,
#               activated: true,
#               activated_at: Time.zone.now)
#end