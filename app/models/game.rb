class Game < ApplicationRecord
  has_many :moderators
  has_many :users, through: :moderators

end
