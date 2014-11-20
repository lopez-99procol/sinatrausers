
require_relative '../spec_helper'

describe User do
  before(:each) do
    @attr = {
    :name => "Warnke",
    :firstname => "Felix",
    :email => "99centprocol_felix@gmail.com",
    :password => "99C3ntPr0C01",
    :password_confirmation => "99C3ntPr0C01"
    }
    
    @nav = {
        :label => "projects",
        :link => "http://http://sinatraprojects-procol.rhcloud.com/",
      }
  end
  
  describe "attribute validation" do

    it "should require a password" do
        expect(User.new(@attr.merge(:password => "", :password_confirmation => ""))).not_to be_valid
    end

    it "should require a matching password confirmation" do
      expect(User.new(@attr.merge(:password_confirmation => "invalid"))).not_to be_valid
    end

    it "should reject short passwords" do
      short_pw = "a" * 5
      expect(User.new(@attr.merge(:password => short_pw, :password_confirmation => short_pw))).not_to be_valid
    end
    
    it "should reject long passwords" do
      long_pw = "b" * 41
      expect(User.new(@attr.merge(:password => long_pw, :password_confirmation => long_pw))).not_to be_valid
    end
  end
  
  # Ensure password encryption is working
  describe "password encryption" do
    before do
      user = User.find_by_email(@attr[:email])
      if !@user.nil?
        @user = user
      else
        @user = User.create(@attr)
        @user.save
       # @navigation = @user.navigation.create(@nav)
      end
    end
    
    it "should have an encrypted password attribute" do
      expect(@user).to respond_to(:encrypted_password)
    end
    
    before do
      user_to_destroy = User.find_by_email(@attr[:email])
      user_to_destroy.destroy
    end
    
    it "should set the encrypted password" do
      expect(@user.encrypted_password).not_to be_blank
    end
  end
  
  # Ensure Authentication is working
  describe "authentication" do
    
    it "should return nil on email/password missmatch" do
      expect(User.authenticate(@attr[:email], "wrongpassword")).to be_nil
    end
    
    it "should return nil for an email adress with no user" do
      expect(User.authenticate("foo@bar.com", @attr[:password])).to be_nil
    end
    
    it "should return the user on email/password match" do
      expect(User.authenticate(@attr[:email], @attr[:password])).to eq(@user)
    end
  end
  
  describe "navigation" do
    it "should create a user with navigation" do
      user = User.find_by_email("99centprocol_lopez@gmail.com")
      expect(user.navigation).not_to be_nil
    end
  end
end

