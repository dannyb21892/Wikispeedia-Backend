class Slug < ApplicationRecord
  belongs_to :game

  def self.make_unique(slug, game)
    puts "making unique slug out of #{slug}"
    match = Slug.all.select{|s| s.name==slug}[0]
    puts match
    if match
      puts "matched slug: #{match}"
      slug = slug+"_"+game.id.to_s
    end
    puts "returning #{slug}"
    return slug
  end
end
