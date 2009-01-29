require 'helpers/general'
require 'digest/sha1'

class User
  include DataMapper::Resource
  
  property :id,			Integer, :serial => true
  property :login,		String,  :key => true
  property :hashed_password, 	String
  property :email,		String
  property :salt,		String
  property :created_at,		DateTime
  
  def password=(pass)
    @password = pass
    self.salt = GeneralHelpers.random_string(10) unless self.salt
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end
  
  def self.authenticate(login, pass)
    u = User.first(:login => login)
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt) == u.hashed_password
    nil
  end
end