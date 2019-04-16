class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: true
  # validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i  
  def generate_token
    loop do
      @token = SecureRandom.hex(20)
      break @token if User.where('? = ANY (tokens)', @token).blank?
    end
    self.tokens = tokens << @token
    save
    @token
  end
end
