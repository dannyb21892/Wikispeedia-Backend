class Game < ApplicationRecord
  has_many :moderators
  has_many :users, through: :moderators
  has_many :headings
  has_many :articles, through: :headings

  validates :title, presence: true
  validates :release_year, numericality: { only_integer: true, less_than_or_equal_to: Date.today.year, greater_than_or_equal_to: 1960 }

  def self.game_from_slug(slug)
    badCharacters = "!@#$%^&*()=+{}|[]\\;':\"`,./<>?}"
    spaceCharacters = " _\n "
    matches = Game.all.select do |game|
      slug.downcase == game.title.downcase.split("").select{|char| !badCharacters.include?(char)}.map{|char| spaceCharacters.include?(char) ? "_" : char}.join("")
    end
    return matches
  end
end
