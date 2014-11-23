require 'rubygems'
require 'sinatra'
require_relative 'models/user.rb'
require_relative 'models/navigation.rb'
require_relative 'models/userprofile.rb'
require 'yaml'
require 'logger'
require 'sinatra/activerecord'
require 'yajl'

# set :database_file, "config/database.yml"

env = ENV["RAILS_ENV"]
case env
when "test"
  set :database, {adapter: "sqlite3", database: "db/test.sqlite3"}
when "production"
  set :database, {adapter: "sqlite3", database: "#{ENV['OPENSHIFT_DATA_DIR']}/production.sqlite3"}
else
  set :database, {adapter: "sqlite3", database: "db/development.sqlite3"}
end

# setting up a logger. levels -> DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN
log = Logger.new(STDOUT)
log.level = Logger::DEBUG 

# HTTP entry points
# get a user by id
get '/api/v1/users/:id' do
  begin
    user = User.find(params[:id])
    if user
      user.to_json
    else
      error 404, {:error => "user not found"}.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# get a user by name
get '/api/v1/users/name/:name' do
  begin
    user = User.find_by_name(params[:name])
    if user
      user.to_json
    else
      error 404, {:error => "user not found"}.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# get a user by email
get '/api/v1/users/email/:email' do
  begin
    user = User.find_by_email(params[:email])
    if user
      user.to_json
    else
      error 404, {:error => "user not found"}.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# get a userprofile by user_id
get '/api/v1/users/:id/userprofile' do
  begin
    userprofile = Userprofile.find_by_user_id(params[:id])
    if userprofile
      userprofile.to_json
    else
      error 404, {:error => "userprofile not found"}.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# get the navigation for a user
get '/api/v1/users/:navid/navigation' do
  begin
    navigation = Navigation.find(params[:navid])
    if navigation
      navigation.to_json
    else
      error 404, {:error => "userprofile not found"}.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# create (post) a new user
post '/api/v1/users' do
  begin
    puts "request = #{request.body}"
    attributes = request.body.read
    puts "attributes[#{attributes}]"
    jsondata = Yajl::Parser.parse(attributes)
    puts "json[#{jsondata}]"
    user = User.create(jsondata) if !jsondata.nil? 
    puts "user[#{user}]"
    if !user.nil? && user.valid?
      user.to_json
    else
      error 400, "user (jsondata) is(are) nil".to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# create (post) a user profile
post '/api/v1/usersprofile' do
  begin
    puts "request = #{request.body}"
    attributes = request.body.read
    puts "attributes[#{attributes}]"
    jsondata = Yajl::Parser.parse(attributes)
    puts "json[#{jsondata}]"
    user_profile = Userprofile.create(jsondata) if !jsondata.nil? 
    puts "user_profile[#{user_profile}]"
    if !user_profile.nil? && user_profile.valid?
      user_profile.to_json
    else
      error 400, "user_profile (jsondata) is(are) nil".to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# update an existing user
put '/api/v1/users/name/:name' do
  user = User.find_by_name(params[:name])
  if user
    begin
      if user.update_attributes(JSON.parse(request.body.read))
        user.to_json
      else
        error 400, user.message.to_json
      end
    rescue => e
      error 400, e.message.to_json
    end
  else
    error 404, {:error => "user not found"}.to_json
  end
end

# update an existing user
put '/api/v1/users/:id' do
  user = User.find(params[:id])
  if user
    begin
      if user.update_attributes(JSON.parse(request.body.read))
        user.to_json
      else
        error 400, user.message.to_json
      end
    rescue => e
      error 400, e.message.to_json
    end
  else
    error 404, {:error => "user not found"}.to_json
  end
end

# destroy an existing user
delete '/api/v1/users/name/:name' do
  begin
    user = User.find_by_name(params[:name])
    if user
      user.destroy
      user.to_json
    else
      error 404, {:error => "user not found"}.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# destroy an existing user
delete '/api/v1/users/:id' do
  begin
    user = User.find(params[:id])
    if user
      user.destroy
      user.to_json
    else
      error 404, {:error => "user not found"}.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# verify a user name and password
post '/api/v1/users/:email/sessions' do
  begin 
    attributes = request.body.read
    puts "attributes[#{attributes}]"
    jsondata = Yajl::Parser.parse(attributes)
    puts "jsondata[#{jsondata}]}"
    email =  jsondata["email"]
    password =  jsondata["password"]
    puts "#{email}/sessions => attributes[#{attributes}]"
    user = User.authenticate(email, password)
    puts "#{email}/sessions => user[#{user.to_json}]"
    if !user.nil?
      user.to_json
    else
      error 400, {:error => "invalid login credentials"}.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

# verify a user name and password
post '/api/v1/users/:id/sessions' do
  begin 
    attributes = JSON.parse(request.body.read)
    user = User.find(
      params[:id], attributes["password"])
    if user
      user.to_json
    else
      error 400, {:error => "invalid login credentials"}.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end