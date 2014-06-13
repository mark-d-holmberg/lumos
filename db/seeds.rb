# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Create the default TOS
Tos.create!(content: "Terms and Conditions")

admin = User.create!(email: 'mark.d.holmberg@gmail.com', password: 'change_me_123', password_confirmation: 'change_me_123')
