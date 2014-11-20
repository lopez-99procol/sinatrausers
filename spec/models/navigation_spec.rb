require_relative '../spec_helper'

describe Navigation do
  
  before(:each) do
    @userattr = {
    :id => "3",
    :name => "felix",
    :email => "99centprocol_felix@gmail.com",
    :password => "99C3ntPr0C01",
    :password_confirmation => "99C3ntPr0C01"
    }
    
    @navattr = {
      :label => "projects",
      :link => "http://http://sinatraprojects-procol.rhcloud.com/",
    }
  end
  
  describe "basic navigation set up" do
    it "should be done (expect basic navigation to be created on users persmissions)" do
      user = User.find_by_email(@userattr[:email])
      user = !nil ? user : User.create(@userattr)
      expect(user.email).to eq(@userattr[:email])
      nav = Navigation.new()
      nav.label = "projects"
      nav.link = "http://http://sinatraprojects-procol.rhcloud.com/"
      nav.user = user
      nav.save
      expect(nav.user).to eq(user)
    end
  end
  
end