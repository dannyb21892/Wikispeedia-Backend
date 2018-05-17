class Api::V1::GamesController < ApplicationController
  def create
    if params[:type] == "checkGame"
      game = Game.all.select{|g| g.title.downcase == params[:title].downcase}[0]
      suggestions = Game.all.select{|game| game.title.downcase.include?(params[:title].downcase) || params[:title].downcase.include?(game.title.downcase)}
      title = game ? game.title : nil
      id = game ? game.id : nil
      render json: {
        gameAlreadyExists: !!game,
        game: {
          title: title,
          id: id
        },
        suggestions: suggestions
      }
    elsif params[:type] == "createGame"
      newgame = Game.create(title: params[:title], release_year: params[:year].to_i)
      params[:moderators].each do |username|
        user = User.find_by(username: username)
        Moderator.create(user_id: user.id, game_id: newgame.id)
      end
      params[:headings].each do |heading|
        Heading.create(name: heading, game_id: newgame.id)
      end
      render json: {
        game: {
          title: newgame.title,
          moderators: newgame.users,
          headings: newgame.headings
        },
        success: !!newgame
      }
    end
  end

  def show
    matches = Game.game_from_slug(params[:id])
    render json: {
      matches: matches
    }
  end

end
