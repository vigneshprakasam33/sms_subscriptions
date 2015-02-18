# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Message.delete_all

$message_categories.each do |k,v|
Message.create(:content => k + " 1" , :category => v)
Message.create(:content => k + " 2" , :category => v)
Message.create(:content => k + " 3" , :category => v)
end