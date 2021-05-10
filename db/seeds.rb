# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# #####################################################################################################################
# User 1
# #####################################################################################################################
profile_one = Profile.new(gender: 'male', birthdate: '1975-11-25')
coordinate_one = Coordinate.new(street: 'Rue Saint-Georges, 44', zip_code: 4444, city: 'Mortadelle', country: 'Fromage')
contact_one = Contact.new(lastname: 'Dummy', firstname: 'Big', phone_number: '0444/44.44.44', email: 'big_dummy@yolo.me')
user_one = User.new(email: 'big_dummy@yolo.me', skip_password_validation: true)
contact_one.coordinate = coordinate_one
profile_one.contact = contact_one
user_one.profile = profile_one
user_one.save
user_one.add_role :admin
# #####################################################################################################################
# User 2
# #####################################################################################################################
profile_two = Profile.new(gender: 'female', birthdate: '1985-08-04')
coordinate_two = Coordinate.new(street: 'Rue du Parlement, 245', zip_code: 5000, city: 'Namur', country: 'Belgique')
contact_two = Contact.new(lastname: 'Dutronc', firstname: 'Anne', phone_number: '0498/11.22.33', email: 'anned@hotmail.com')
user_two = User.new(email: 'anned@hotmail.com', skip_password_validation: true)
contact_two.coordinate = coordinate_two
profile_two.contact = contact_two
user_two.profile = profile_two
user_two.save
# #####################################################################################################################
# User 3
# #####################################################################################################################
profile_three = Profile.new(gender: 'male', birthdate: '2000-09-30')
coordinate_three = Coordinate.new(street: 'Rue de l\'Atomium, 17', zip_code: 1000, city: 'Bruxelles', country: 'Belgique')
contact_three = Contact.new(lastname: 'Lagaffe', firstname: 'Vincent', phone_number: '0471/54.21.87', email: 'vincentlagaffe@skynet.be')
user_three = User.new(email: 'vincentlagaffe@skynet.be', skip_password_validation: true)
contact_three.coordinate = coordinate_three
profile_three.contact = contact_three
user_three.profile = profile_three
user_three.save
# #####################################################################################################################
# User 4
# #####################################################################################################################
profile_four = Profile.new(gender: 'female', birthdate: '1956-12-01')
coordinate_four = Coordinate.new(street: 'Rue des Saint-Pères, 61', zip_code: 75006, city: 'Paris', country: 'France')
contact_four = Contact.new(lastname: 'Chazal', firstname: 'Claire', phone_number: '+33123/45.67.89', email: 'claire_chazal@tfi.fr')
user_four = User.new(email: 'claire_chazal@tfi.fr', skip_password_validation: true)
contact_four.coordinate = coordinate_four
profile_four.contact = contact_four
user_four.profile = profile_four
user_four.save
user_one.add_role :admin
# #####################################################################################################################
# User 5
# #####################################################################################################################
profile_five = Profile.new(gender: 'male')
contact_five = Contact.new(lastname: 'Lucas', firstname: 'George', email: 'lucas_george@movies.us', phone_number: '123456789')
user_five = User.new(email: 'lucas_george@movies.us', skip_password_validation: true)
profile_five.contact = contact_five
user_five.profile = profile_five
user_five.save
