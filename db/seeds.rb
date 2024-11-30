# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Program.create(name: "Mini")
Program.create(name: "Major")
Coordinator.create(name:"A-section-coordinator", password:"pda123", section: 'A')
Coordinator.create(name:"B-section-coordinator", password:"pda123", section: 'B')
Coordinator.create(name:"C-section-coordinator", password:"pda123", section: 'C')
