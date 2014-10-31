#require File.dirname(__FILE__) + '/../client'
require_relative '../app/client.rb'

# NOTE: to run these specs you must have the service running locally. Do like this:
# ruby service.rb -p 3000 -e test

# Also note that after a single run of the tests the server must be restarted to reset
# the database. We could change this by deleting all Userss in the test setup.
describe "client" do
  before(:all) do
    Users.base_uri = "http://localhost:4567"
  end
  
  before(:each) do
    @attr = {
    :id => "3",
    :name => "felix",
    :email => "99centprocol_felix@gmail.com",
    :password => "99C3ntPr0C01",
    :password_confirmation => "99C3ntPr0C01"
    }
  end

  it "finding known Users by id [expect response code eq 200]" do
    response = Users.find(1)
    expect(response.code).to eq(200)
  end

  it "finding known Users by name [expect response code eq 200]" do
    response = Users.find_by_name("lopez")
    expect(response.code).to eq(200)
  end

  it "finding unknown Users by name [expect response code eq 404]" do
    response = Users.find_by_name("gosling")
    expect(response.code).to eq(404)
  end

  it "creating Users [expect response code eq 200]" do
    response = Users.create(@attr)
    expect(response.code).to eq(200)
  end

  it "updating a Users [expect response code eq 200]" do
    response = Users.update(1, :bio => "scrum master and scrum team")
    expect(response.code).to eq(200)
  end

  it "destroy a Users [expect response code eq 200]" do
    response = Users.destroy(3)
    expect(response.code).to eq(200)
  end

  it "login with correct credentials [expect response code eq 200]" do
    response = Users.login(1, "99C3ntPr0C01")
    expect(response.code).to eq(200)
  end

  it "login with invalid credentials [expect response code eq 404]" do
    response = Users.login(1, "wrongpassword")
    expect(response.code).to eq(400)
  end
end