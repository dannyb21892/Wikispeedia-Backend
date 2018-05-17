class Heading < ApplicationRecord
  belongs_to :game
  has_many :articles
end
