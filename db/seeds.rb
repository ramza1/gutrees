# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

 Category.create([{name: "Organization"}, {name: "Company"}, {name:"Institution"}, {name: "Place"}, {name: "Local Business"},
                 {name: "Brand"}, {name: "Product"}, {name: "Artist"}, {name: "Band"}, {name: "Public Figure"}, {name: "Entertainment"},
                 {name: "Cause"}, {name: "Community"}, {name: "Personal"}])
