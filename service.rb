require 'rubygems'
require 'sinatra'
require_relative 'models/user.rb'
require 'yaml'
require 'logger'
require "sinatra/activerecord"

# set :database_file, "config/database.yml"

env = ENV["RAILS_ENV"]
case env
when "test"
  set :database, {adapter: "sqlite3", database: "db/test.sqlite3"}
when "production"
  set :database, {adapter: "sqlite3", database: "#{ENV[OPENSHIFT_DATA_DIR]}/production.sqlite3"}
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

# create (post) a new user
post '/api/v1/users' do
  begin
    user = User.create(JSON.parse(request.body.read))
    puts "request = #{request.body.read}"
    if user.valid?
      user.to_json
    else
      error 400, user.errors.to_json
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
post '/api/v1/users/name/:name/sessions' do
  begin 
    attributes = JSON.parse(request.body.read)
    user = User.find_by_name_and_password(
      params[:name], attributes["password"])
    if user
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