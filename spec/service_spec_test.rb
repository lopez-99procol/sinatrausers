require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Server' do
  it "should get home page" do
    get '/api/v1/users/name/lopez'
    last_response.should be_ok
    assert last_response.body.include?('name')
  end
end