class User < ApplicationRecord
  ALLOWED_SEARCH_PARAMS = %w(email full_name metadata).freeze

  validates :email, :phone_number, :password, :key, presence: true
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
end