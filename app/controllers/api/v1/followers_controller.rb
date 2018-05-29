class Api::V1::FollowersController < ApplicationController
  def show
    user = User.find_by(username: params[:id])
    games = user.followed_games
    followers = games.map{|g| {url: "/games/#{g.slug.name}", game: g}}

    render json: {
      success: !!games,
      followers: followers
    }
  end

  def create
    user = User.find_by(username: params[:username])
    game = Game.find(params[:game])
    if user && game
      if params[:type] == "addFollower"
        follower = Follower.create(user_id: user.id, game_id: game.id)
        render json: {
          success: !!follower
        }
      elsif params[:type] == "remFollower"
        Follower.find_by(user_id: user.id, game_id: game.id).destroy
        render json: {
          success: true
        }
      end
    end
  end
end
