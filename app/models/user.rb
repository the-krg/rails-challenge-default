class User < ApplicationRecord
  validates :email, :phone_number, :password, :key, presence: true
  validates :email, :phone_number, :key, :account_key, uniqueness: true

  validates :email, length: { maximum: 200 }
  validates :phone_number, length: { maximum: 20 }
  validates :full_name, length: { maximum: 200 }
  validates :password, length: { maximum: 100 }
  validates :key, length: { maximum: 100 }
  validates :account_key, length: { maximum: 100 }
  validates :metadata, length: { maximum: 2000 }
end