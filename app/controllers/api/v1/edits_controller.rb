class Api::V1::EditsController < ApplicationController
  def index
    edits = Edit.allSortedApprovedEdits
    output = edits.map{|e| {edit: e, url: "/games/#{e.article.heading.game.slug.name}/#{e.article.article_slug.name}"}}
    render json: {
      success: !!output,
      edits: output
    }
  end
end
