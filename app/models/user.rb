class User < ApplicationRecord
  has_secure_password
  has_many :moderators
  has_many :games, through: :moderators
  has_many :followers
  has_many :edits
  has_many :home_edits
  has_many :articles, through: :edits
  has_many :homes, through: :edits
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :username, length: { minimum: 3, maximum: 20 }, on: :create
  validates :password, length: { minimum: 6, maximum: 20 }, on: :create

  def notifications
    output = []
    self.moderators.map{|m| m.game}.each do |g|
      g.articles.each do |a|
        a.editsSorted.each do |e|
          if e.status == "pending"
            output.push({edit: e, url: "http://localhost:3001/games/#{g.slug.name}/#{a.article_slug.name}"})
          end
        end
      end
      g.home.home_edits.each do |e|
        if e.status == "pending"
          output.push({edit: e, url: "http://localhost:3001/games/#{g.slug.name}/home"})
        end
      end
    end
    return output.sort_by{|e| e[:edit].created_at}.reverse
  end

  def followed_games
    self.followers.map{|f| f.game}
  end

end
