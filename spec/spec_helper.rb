# spec/spec_helper.rb
ENV['SINATRA_ENV'] = 'test'

require File.dirname(__FILE__) + '/../app/service'
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Sinatra::Application
end