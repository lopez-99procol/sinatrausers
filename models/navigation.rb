require 'sinatra/activerecord'
require 'json'

class Navigation < ActiveRecord::Base
  #attr_accessor :label, :link, :user_id
  
  has_many :users, :through => :userprofile
  
end