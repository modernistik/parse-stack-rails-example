# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Upgrading Parse-Server schema collections..."
Parse.auto_upgrade! # Auto_upgrade all models

# Create a sample Parse::User
puts "Creating sample Parse::User...."
user = Parse::User.first_or_create({username: "frankie"},{password: "1234"})
user.save

puts "Creating sample Artist...."
franky = Artist.first_or_create({name: "Frank Sinatra"})
franky.save

franky.fans.add user
puts "Creating sample Songs...."
song1 = Song.first_or_create(name: "Fly Me to the Moon")
song1.released = 1964
song1.genres = ['jazz','big band']
song1.artist = franky
song1.save # save single song

song2 = Song.first_or_create(name: "Come Fly With Me")
song2.released = 1957
song2.genres = ['vocal', 'jazz','traditional pop']
song2.artist = franky

song3 = Song.first_or_create(name: "New York, New York")
song3.released = 1979
song3.genres = ['jazz','traditional pop']
song3.artist = franky

song4 = Song.first_or_create(name: "My Way")
song4.released = 1969
song4.genres = ['reprise','traditional pop']
song4.artist = franky

[song2,song3,song4,franky].save # batch save

count = Song.count(artist: franky)
puts "Artist `#{franky.name}` has #{count} songs and #{franky.fans.count} fans."
puts "User `#{user.username}` is a fan of `#{franky.name}`."
