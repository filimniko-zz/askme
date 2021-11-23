require "openssl"

class User < ApplicationRecord
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  USERNAME_MAX_LENGTH = 40
  USERNAME_REGEX = /\A[a-zA-Z0-9_]+\z/
  EMAIL_REGEX = /^[\w\d\.]+@[\w\d]+\.\w/i

  attr_accessor :password

  has_many :questions
  before_validation :text_to_downcase
  before_save :encrypt_password

  validates :email,
            presence: true,
            uniqueness: true

  validates_each :email do |record, attr, value|
    record.errors.add(attr, 'email is incorrect') unless value =~ EMAIL_REGEX
  end

  validates :username,
            presence: true,
            uniqueness: true,
            length: { maximum: USERNAME_MAX_LENGTH },
            format: { with: USERNAME_REGEX, message: "only allows letters" }

  validates :password,
            presence: true,
            confirmation: true

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

  def text_to_downcase
    username.downcase! if username.present?
    email.downcase! if email.present?      
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
