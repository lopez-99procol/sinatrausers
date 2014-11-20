require 'sinatra/activerecord'

class Userprofile < ActiveRecord::Base
  attr_accessor :navigations_id, :users_id, :renewaldate
  belongs_to :user
  belongs_to :navigation
end