# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user1 = User.create(username: "test_user", password: "test_password")
user2 = User.create(username: "test_user2", password: "test_password2")

game1 = Game.create(title: "test_title")

mod_slot = Moderator.create(user_id: user1.id, game_id: game1.id)
