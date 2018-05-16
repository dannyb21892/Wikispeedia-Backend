class Game < ApplicationRecord
  has_many :moderators
  has_many :users, through: :moderators

  validates :title, presence: true
  validates :release_year, numericality: { only_integer: true, less_than_or_equal_to: Date.today.year, greater_than_or_equal_to: 1960 }
end
