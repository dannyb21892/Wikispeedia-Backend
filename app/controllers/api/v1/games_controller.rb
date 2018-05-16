class Api::V1::GamesController < ApplicationController
  def create
    if params[:type] == "checkGame"
      game = Game.find_by(title: params[:title])
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
      # Game.create(title: params[:title])
      render json: {
        game: {
          title: title,
        },
        success: true
      }
    end
  end

end
