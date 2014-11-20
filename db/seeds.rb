# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.create(
  {
    :name => "Krüger",
    :firstname => "Thomas",
    :email => "99centprocol_lopez@gmail.com",
    :password => "Password1",
    :password_confirmation => "Password1"
  }
)
navigations = Navigation.create(
  [{
    :label => "collaboration",
    :link => "http://http://sinatracollaboration-procol.rhcloud.com/",
    :free => false
  },   
  {
    :label => "projects",
    :link => "http://http://sinatraprojects-procol.rhcloud.com/",
    :free => true
  }]
)

userProfile = Userprofile.new()
userProfile.user = user
userProfile.navigation = Navigation.first
userProfile.renewaldate = Time.new(2099, 12, 31, 9, 10, 11 ).strftime("%Y-%m-%dT%H:%M:%S")
userProfile.save
#:user_id => user.id, :navigations_id => navigations[0].id, :renewaldate => 
#Userprofile.create(:user_id => user.id, :navigations_id => navigations[1].id, :renewaldate => Time.new(2099,12,31).strftime("%Y-%m-%dT%H:%M:%S"))