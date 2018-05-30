class Api::V1::EditsController < ApplicationController
  def index
    edits = Edit.allSortedApprovedEdits
    output = edits.map{|e| {edit: e, url: "/games/#{e.article.heading.game.slug.name}/#{e.article.article_slug.name}", game: e.article.heading.game.title, timestamp: e.created_at.strftime("edited at %R on %b %e")}}
    render json: {
      success: !!output,
      edits: output
    }
  end

  def create
    user = User.find_by(username: params[:user])
    edits = user.edits.map{|e| {edit: e, url: "/games/#{e.article.heading.game.slug.name}/#{e.article.article_slug.name}", game: e.article.heading.game.title, timestamp: e.created_at.strftime("edited at %R on %b %e"), time: e.created_at.to_time.to_i}}
    home_edits = user.home_edits.map{|e| {edit: e, url: "/games/#{e.home.game.slug.name}/home", game: e.home.game.title, timestamp: e.created_at.strftime("edited at %R on %b %e"), time: e.created_at.to_time.to_i}}
    output = {edits: edits, home_edits: home_edits}
    render json: {
      edits: output
    }
  end
end
