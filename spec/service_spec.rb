# spec/service_spec.rb
require 'spec_helper'

describe "user-service" do
  describe "{GET requests}" do
    # 1
    it "should allow accessing known user id [response.status 200]" do
      get '/api/v1/users/1'
      expect(last_response.status).to eq(200)
    end
  
   # 2
    it "should deny accessing unknown user id [response.status 404]" do
      get '/api/v1/users/9999'
      expect(last_response.status).to eq(400)
    end
   # 3
    it "should allow accessing known user name [response.status 200]" do
      get '/api/v1/users/name/lopez'
      expect(last_response.status).to eq(200)
    end
  
   # 4
    it "should deny accessing unknown user name [response.status 404]" do
      get '/api/v1/users/name/HXYBFRTO'
      expect(last_response.status).to eq(404)
    end
    
   # 9
   it "should allow accessing known user with email" do
     get '/api/v1/users/email/99centprocol-lopez@gmail.com'
     expect(last_response.status).to eq(200)
   end
   
   # 10
    it "should allow deny accessing user with unknown email" do
      get '/api/v1/users/email/99centprocol-lopezzzz@gmail.com'
      expect(last_response.status).to eq(200)
    end
  end
  
  describe "{POST requests}" do
    # 5
    it "should create a new user [response.status 200]" do
      post '/api/v1/users', {
          :name     => "EHGSBYID",
          :email    => "no spam",
          :password => "whatever",
          :password_confirmation => "whatever",
          :bio      => "southern bell"}.to_json
      expect(last_response.status).to eq(200)
      get '/api/v1/users/name/EHGSBYID'
      retrieved_userdata = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      $created_user_id = retrieved_userdata["id"]
    end
    
    # 6
    it "should authenticate user with valid id and password [response.status 200]" do
      post '/api/v1/users/1/sessions', {
        :id => 1,
        :password => "99c3ntpr0c01"
      }
      expect(last_response.status).to eq(200)
    end
  end
  
  describe "{PUT requests}" do
    # 7
    it "should update a user [response.status 200]" do
      put '/api/v1/users/1', {
        :bio => "did some certificate"
      }.to_json
      get '/api/v1/users/1'
      retrieved_userdata = JSON.parse(last_response.body)
      expect(retrieved_userdata["bio"]).to eq("did some certificate")
    end
  end

  describe "{DELETE request}" do
    # 8
    it "should delete a user [response.status 200]" do
      get '/api/v1/users/name/EHGSBYID'
      created_user_data = JSON.parse(last_response.body)
      created_user_data_id = created_user_data["id"]
      delete "/api/v1/users/#{created_user_data_id}"
      expect(last_response.status).to eq(200)
    end
  end
end