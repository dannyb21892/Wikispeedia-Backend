class Api::V1::GamesController < ApplicationController
  def create
    if params[:type] == "checkGame"
      game = Game.all.select{|g| g.title.downcase == params[:title].downcase}[0]
      suggestions = Game.all.select{|game| game.title.downcase.include?(params[:title].downcase) || params[:title].downcase.include?(game.title.downcase)}
      slugs = suggestions.map{|s| s.slug}
      title = game ? game.title : nil
      id = game ? game.id : nil
      slug = game ? game.slug : nil
      render json: {
        gameAlreadyExists: !!game,
        game: {
          title: title,
          id: id,
          slug: slug
        },
        suggestions: {games: suggestions, slugs: slugs}
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
      home = Home.create(game_id: newgame.id, title: "home", content: "", html_content: "")
      creator = User.find_by(username: params[:moderators].last)
      HomeEdit.create(home_id: home.id, title: "home", content: "", html_content: "", status: "approved", user_id: creator.id)
      newslug = Slug.make_unique(params[:slug], newgame)
      Slug.create(name: newslug, game_id: newgame.id)

      render json: {
        game: {
          title: newgame.title,
          moderators: newgame.users,
          headings: newgame.headings,
          slug: newgame.slug
        },
        success: !!newgame
      }
    elsif params[:type] == "home"
      games = Game.all.map{|game| {title: game.title, release_year: game.release_year, slug: (game.slug ? game.slug.name : nil), articles: game.articles.length}}
      output = games.sort_by{|g| g[:articles]}.reverse

      render json: {
        games: output
      }
    end
  end

  def index
      games = Game.all.map{|game| {title: game.title, release_year: game.release_year, slug: (game.slug ? game.slug.name : nil)}}
      render json: {
        games: games
      }
  end

  def show
    match = Slug.find_by(name: params[:id])#params[:id] is the slug from the URL
    output = match ? match.game : nil
    headings = match ? match.game.headings : nil
    articles = match ? headings.map{|h| h.articles} : nil

    render json: {
      match: output,
      headings: headings,
      articles: articles
    }
  end

end
