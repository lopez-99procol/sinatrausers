require 'typhoeus'
require 'json'

class Users
  class << self; attr_accessor :base_uri end

  def self.find(id)
    request = "#{base_uri}/api/v1/users/#{id}"
    # puts "self.find->request(#{request})"
    response = Typhoeus::Request.get(request)
    # puts "self.find->response(#{response.code})"
    if response.code == 200
      JSON.parse(response.body)["user"]
    elsif response.code == 404
      nil
    else
      raise response.body
    end
    response
  end

  def self.find_by_name(name)
    request = "#{base_uri}/api/v1/users/name/#{name}"
    response = Typhoeus::Request.get(request)
    if response.code == 200
      JSON.parse(response.body)["user"]
    elsif response.code == 404
      nil
    else
      raise response.body
    end
    response
  end
  
  def self.find_by_email(email)
    request = "#{base_uri}/api/v1/users/email/#{email}"
    # puts "find_by_email:request(#{request})"
    response = Typhoeus::Request.get(request)
    if response.code == 200
      JSON.parse(response.body)["user"]
    elsif response.code == 404
      nil
    else
      raise response.body
    end
    response
  end

  def self.create attributes
    response = Typhoeus::Request.post("#{base_uri}/api/v1/users", :body => attributes.to_json )
    # puts "create:response(#{response})"
    if response.code == 200
      JSON.parse(response.body)['user']
    elsif response.code == 400
      nil
    else
      raise response.body
    end
    response
  end

  def self.update_by_name(name, attributes)
    response = Typhoeus::Request.put("#{base_uri}/api/v1/users/name/#{name}", :body => attributes.to_json)
    if response.code == 200
      JSON.parse(response.body)['user']
    elsif response.code == 400 || response.code == 404
      nil
    else
      raise response.body
    end
    response
  end
  
  def self.update(id, attributes)
    request = "#{base_uri}/api/v1/users/#{id}"
    response_body = attributes.to_json
    response = Typhoeus::Request.put(request, :body => response_body)
    # puts "update.request(#{request}->response(#{response.body})))"
    if response.code == 200
      JSON.parse(response.body)['user']
    elsif response.code == 400 || response.code == 404
      nil
    else
      raise response.body
    end
    response
  end

  def self.destroy_by_name(name)
    response = Typhoeus::Request.delete("#{base_uri}/api/v1/users/name/#{name}")
    response # response.code == 200
  end
  
  def self.destroy(id)
    # puts "destroy:id(#{id})"
    request = "#{base_uri}/api/v1/users/#{id}"
    # puts "destroy:request(#{request})"
    response = Typhoeus::Request.delete(request)
    response # response.code == 200
  end

  def self.login_by_name(name, password)
    response = Typhoeus::Request.post("#{base_uri}/api/v1/users/name/#{name}/sessions", :body => {:password => password}.to_json)
    if response.success? # response.code == 200
      JSON.parse(response.body)["user"]
    elsif response.code == 400
      nil
    else
      raise response.body
    end
    response
  end
  
  # def self.login(id, password)
  #   request = "#{base_uri}/api/v1/users/#{id}/sessions"
  #   puts "login:request(#{request})"
  #   response = Typhoeus::Request.post(request, :body => {:password => password}.to_json)
  #   if response.success? # response.code == 200
  #     JSON.parse(response.body)["user"]
  #   elsif response.code == 400
  #     nil
  #   else
  #     raise response.body
  #   end
  #   response
  # end
  
  def self.login(email, password)
    request = "#{base_uri}/api/v1/users/#{email}/sessions"
    #puts "login:request(#{request})"
    response = Typhoeus::Request.post(request, :body => {:email => "#{email}", :password => password}.to_json)
    if response.success? # response.code == 200
      JSON.parse(response.body)["user"]
    elsif response.code == 400
      nil
    else
      raise response.body
    end
    response
  end
  
end