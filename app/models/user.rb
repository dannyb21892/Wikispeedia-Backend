class User < ApplicationRecord
  has_secure_password
  has_many :moderators
  has_many :games, through: :moderators
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :username, length: { minimum: 3, maximum: 20 }, on: :create
  validates :password, length: { minimum: 6, maximum: 20 }, on: :create

  def notifications
    output = []
    self.games.each do |g|
      g.articles.each do |a|
        a.editsSorted.each do |e|
          if e.status == "pending"
            output.push({edit: e, url: "http://localhost:3001/games/#{e.article.heading.game.slug.name}/#{e.title}"})
          end
        end
      end
    end
    return output.sort_by{|e| e[:edit].created_at}.reverse
  end

end
