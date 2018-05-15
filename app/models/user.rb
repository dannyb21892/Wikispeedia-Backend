class User < ApplicationRecord
  has_secure_password
  has_many :moderators
  has_many :games, through: :moderators
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :username, length: { minimum: 3, maximum: 20 }, on: :create
  validates :password, length: { minimum: 6, maximum: 20 }, on: :create
end
