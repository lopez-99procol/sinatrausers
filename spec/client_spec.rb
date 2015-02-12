#require File.dirname(__FILE__) + '/../client'
require_relative '../client.rb'
require_relative '../models/user.rb'

databases = {}
databases['adapter'] = 'sqlite3'
databases['database'] = 'db/development.sqlite3'

require 'sinatra/activerecord'
ActiveRecord::Base.establish_connection(databases)


# NOTE: to run these specs you must have the service running locally. Do like this:
# ruby service.rb -p 3000 -e test

# Also note that after a single run of the tests the server must be restarted to reset
# the database. We could change this by deleting all Userss in the test setup.
describe "client" do
  before(:all) do
    Users.base_uri = "http://0.0.0.0:9292"
  end
  
  before(:each) do
    @attr = {
    :firstname => "Felix",
    :name => "Warnke",
    :email => "#{('a'..'z').to_a.shuffle.join}@gmail.com",
    :password => "Password1",
    :password_confirmation => "Password1"
    }
    
  end

  it "finding known Users by id [expect response code eq 200]" do
    response = Users.find(1)
    expect(response.code).to eq(200)
  end

  it "finding known Users by email [expect response code eq 200]" do
    response = Users.find_by_email("99centprocol_lopez@gmail.com")
    expect(response.code).to eq(200)
  end

  it "finding unknown Users by email [expect response code eq 404]" do
    response = Users.find_by_email("99centprocol_@gmail.com")
    expect(response.code).to eq(404)
  end

  it "creating Users [expect response code eq 200]" do
    response = Users.create(@attr)
    @created_user_id = JSON.parse(response.body)['id']
    #puts "created_user:id(#{@created_user_id})"
    expect(response.code).to eq(200)
  end

  # it "updating a Users [expect response code eq 200]" do
  #   response = Users.update(1, :bio => "scrum master and scrum team")
  #   expect(response.code).to eq(200)
  # end

  it "destroy a Users [expect response code eq 200]" do
    user_id = User.last.id
    #puts "try to destroy user with id(#{user_id})"
    response = Users.destroy(user_id)
    expect(response.code).to eq(200)
  end

  it "login with correct credentials [expect response code eq 200]" do
    response = Users.login(User.last.email, "Password1")
    expect(response.code).to eq(200)
  end

  it "login with invalid credentials [expect response code eq 404]" do
    response = Users.login(@attr[:email], "wrongpassword")
    expect(response.code).to eq(400)
  end
end