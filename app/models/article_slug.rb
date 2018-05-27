class ArticleSlug < ApplicationRecord
  belongs_to :article

  def self.make_unique(slug, game)
    match = Slug.all.select{|s| s.name==slug}[0]
    if match
      slug = slug+"_"+game.id.to_s
    end
    return slug
  end
end
