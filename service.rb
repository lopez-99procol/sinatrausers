require 'rubygems'
require 'active_record'
require 'sinatra'
require_relative 'models/user.rb'
require 'yaml'
require 'logger'

# setting up a logger. levels -> DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN
log = Logger.new(STDOUT)
log.level = Logger::DEBUG 

# setting up our environment
env_index = ARGV.index("-e")
env_arg = ARGV[env_index + 1] if env_index
env = ENV['SINATRA_ENV'] || ENV['RAILS_ENV']
log.debug "env: #{env}"

# connecting to the database
use ActiveRecord::ConnectionAdapters::ConnectionManagement # close connection to the DDBB properly...https://github.com/puma/puma/issues/59
databases = YAML.load_file("config/database.yml")
ActiveRecord::Base.establish_connection(databases[env])
log.debug "#{databases[env]} database connection established..."

# creating fixture data (only in test mode)
if env == 'test'
  #User.destroy_all
  User.create(
   :id => 1,
   :name => "lopez", 
   :email => "99centprocol-lopez@gmail.com", 
   :password => "99c3ntpr0c01",
   :bio => "scrum master")
   
  User.create(
   :id => 2,
   :name => "frido",
   :email => "99centprocol-frido@gmail.com",
   :password => "99c3ntpr0c01",
   :bio => "product owner")
   
  log.debug "fixture data created in test database..."
end


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