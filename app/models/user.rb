class User < ApplicationRecord
  has_secure_password

  ALLOWED_SEARCH_PARAMS = %w(email full_name metadata).freeze

  before_create :generate_key

  validates :email, :phone_number, :password, presence: true
  validates :email, :phone_number, :key, :account_key, uniqueness: true

  validates :email, length: { maximum: 200 }
  validates :phone_number, length: { maximum: 20 }
  validates :full_name, length: { maximum: 200 }
  validates :password, length: { maximum: 100 }
  validates :key, length: { maximum: 100 }
  validates :account_key, length: { maximum: 100 }
  validates :metadata, length: { maximum: 2000 }

  def self.search(search_params)
    allowed_params = search_params.select { |param| ALLOWED_SEARCH_PARAMS.include?(param) }

    where(allowed_params)
  end

  private

  def generate_key
    self.key = SecureRandom.hex(32)
  end
end