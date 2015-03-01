require 'sinatra/activerecord'

class Micropost < ActiveRecord::Base
  #attr_accessor :content
  
  belongs_to :user
  
  default_scope {order(:created_at => :desc)}
  
  validates :content, :presence => true
  validates :user_id, :presence => true
end