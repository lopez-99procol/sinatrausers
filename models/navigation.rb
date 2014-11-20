require 'sinatra/activerecord'

class Navigation < ActiveRecord::Base
  #attr_accessor :label, :link, :user_id
  
  has_many :users, :through => :userprofile
  
end