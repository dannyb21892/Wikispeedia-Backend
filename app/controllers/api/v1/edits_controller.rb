class Api::V1::EditsController < ApplicationController
  def index
    edits = Edit.allSortedApprovedEdits
    output = edits.map{|e| {edit: e, url: "/games/#{e.article.heading.game.slug.name}/#{e.article.article_slug.name}", game: e.article.heading.game.title, timestamp: e.created_at.strftime("edited at %R on %b %e")}}
    render json: {
      success: !!output,
      edits: output
    }
  end
end
