require 'sinatra/activerecord'

class Userprofile < ActiveRecord::Base
  attr_accessor :navigations, :users, :renewaldate
  belongs_to :user
  belongs_to :navigation
end