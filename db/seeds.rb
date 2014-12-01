# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.new(
    :name => "Krüger",
    :firstname => "Thomas",
    :email => "99centprocol_lopez@gmail.com",
    :password => "Password1",
    :password_confirmation => "Password1"
)
nav1 = Navigation.new(:label => "Projects", :link => "http://sinatraprojects-procol.rhcloud.com/", :free => true)
user.navigations << nav1
nav1.save!

nav2 = Navigation.new(:label => "Collaboration", :link => "http://sinatraprojects-procol.rhcloud.com/", :free => false)
user.navigations << nav2
nav2.save

user.save!