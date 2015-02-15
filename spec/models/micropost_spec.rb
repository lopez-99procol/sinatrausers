require_relative '../spec_helper'
require_relative '../../client.rb'
require_relative '../../models/micropost.rb'
require_relative '../../models/user.rb'

describe "micropost" do
  
  before(:each) do
    @user = User.last
    @mp = @user.microposts
    @mpattr = { :content => "value for content" }
  end

  it "should create a new instance given valid attributes" do
    @user.microposts.create!(@mpattr)
  end
  

  describe "user associations" do
    before(:all) do
      @uattr = {
        :firstname => "#{('a'..'z').to_a.shuffle.join}",
        :name => "#{('a'..'z').to_a.shuffle.join}",
        :email => "#{('a'..'z').to_a.shuffle.join}@gmail.com",
        :password => "Password1",
        :password_confirmation => "Password1"
      }
      @user = User.create(@uattr)
    end
    
    before(:each) do
      @micropost = @user.microposts.create(@mpattr)
       
    end
    
    it "should have a user attribute" do
      #@micropost.should respond_to(:user)
      expect(@micropost).to respond_to(:user)
    end
    
    it "should have the right associated user" do
      #@micropost.user_id.should == @user.id
      expect(@micropost.user_id).to eq(@user.id)
      #@micropost.user.should == @user
      expect(@micropost.user).to eq(@user)
    end
    
    it "should destroy associated microposts" do
      @user.destroy
      @mp.each do |m|
        expect(Micropost.find_by_id(m.id)).to eq(nil)
      end
    end
    
  end

  describe "validations" do
    
    it "should require a user id" do
      expect(Micropost.new(@mpattr)).not_to eq(true)
    end
    
    it "should require non blank content" do
      expect(@user.microposts.build(:content => " ")).not_to eq(true)
    end    
  end

end