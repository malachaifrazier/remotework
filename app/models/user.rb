class User < ActiveRecord::Base
  has_secure_password
  has_secure_token :password_reset_token
  validates_uniqueness_of :email
end
