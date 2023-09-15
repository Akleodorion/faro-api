# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Event.destroy_all
Event.create(name: 'Evenement 1', description: 'Une decription simple et efficace qui fonctionne plutot bien que dire de
             plus a vrai dire je ne sais pas', date: DateTime.new(2023, 9, 11), location: 'Lille', category: 'loisir',
             free: false, user_id: 20)
