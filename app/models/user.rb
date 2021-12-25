require "openssl"
require "uri"

class User < ApplicationRecord
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  USERNAME_MAX_LENGTH = 40
  USERNAME_REGEX = /\A[a-zA-Z0-9_]+\z/
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i


  attr_accessor :password

  has_many :questions
  before_validation :text_to_downcase
  before_save :encrypt_password

  validates :email,
            presence: true ,
            uniqueness: true,
            format: { with: EMAIL_REGEX }

  validates :username,
            presence: true,
            uniqueness: true,
            length: { maximum: USERNAME_MAX_LENGTH },
            format: { with: USERNAME_REGEX }

  validates :password,
            presence: true,
            confirmation: true

  validates :avatar_url,
            format: URI::regexp(%w[http https]),
            allow_blank: true

  def self.hash_to_string(password_hash)
    password_hash.unpack("H*")[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)
    if user.present? and user.password_hash == User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST))
      user
    else
      nil
    end
  end  

  private

  def text_to_downcase
    username&.downcase!
    email&.downcase!     
  end

  def encrypt_password
    if self.password.present?
      # Salt
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      #Hash
      self.password_hash = User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST))
    end
  end
end
