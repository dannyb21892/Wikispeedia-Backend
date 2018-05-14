class User < ApplicationRecord
  has_secure_password
  has_many :moderators
  has_many :games, through: :moderators
  validates :username, presence: true
  validates :username, uniqueness: true
end
