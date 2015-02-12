require 'digest'
require 'sinatra/activerecord'

class User < ActiveRecord::Base
  attr_accessor :password, :userprofile
  #attr_accessible :name, :email, :password, :passwort_confirmation
  validates_uniqueness_of :email
  
  # Automatically create the virtual attribute 'password_confirmation'
  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..40}
                    
  has_many :userprofile                      
  has_many :navigations, :through => :userprofile
  has_many :microposts, :dependent => :destroy
  
  accepts_nested_attributes_for :navigations
  
  # Set an own primary_key for testing needs
  self.primary_key = :id
  
  before_save :encrypt_password
  
  def to_json
    super(:except => [:password])
  end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, password)
    user = User.find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(password)
  end
  
  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
end