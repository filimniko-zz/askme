require "openssl"

class User < ApplicationRecord
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new

  has_many :questions

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true, on: :create
  validates :username, length: { maximum: 40 }
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters (\"A-Z\", \"a-z\", \"_\")" }

  validates_each :email do |record, attr, value|
    record.errors.add(attr, 'email is incorrect') unless value =~ /^[\w\d\.]+@[\w\d]+\.\w/i
  end

  before_validation :username_validation

  def username_validation
    username.downcase!
  end

  attr_accessor :password

  validates :password, presence: true
  validates :password, confirmation: true

  before_save :encrypt_password

  def encrypt_password
    if self.password.present?
      # Salt
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      #Hash
      self.password_hash = User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST))
    end
  end

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
end
