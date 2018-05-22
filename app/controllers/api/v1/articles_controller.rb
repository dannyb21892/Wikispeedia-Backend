class Api::V1::ArticlesController < ApplicationController
  def create
    if params[:type] == "getArticle"
      slug = Slug.find_by(name: params[:game])
      if slug
        game = slug.game
        article = game.articles.select{|a| a.title.downcase == params[:article].downcase}[0]
        articles = game.headings.map{|h| h.articles}
      end
      if article
        render json: {
          success: true,
          markdown: article.content,
          html: article.html_content,
          title: article.title,
          headings: game.headings,
          articles: articles,
          game: game
        }
      else
        render json: {
          success: false,
          errors: "No article by that name found",
          headings: game.headings,
          articles: articles,
          game: game
        }
      end
    elsif params[:type] == "updateArticle"
      game = Slug.find_by(name: params[:game]).game
      article = game.articles.select{|a| a.title.downcase == params[:article].downcase}[0]

      article.content = params[:content]
      article.html_content = params[:html_content]
      article.title = params[:title]
      if article.save
        render json: {
          success: true,
          markdown: article.content,
          html: article.html_content,
          title: article.title
        }
      else
        render json: {
          success: false,
          errors: "Edit failed"
        }
      end
    elsif params[:type] == "newArticle"
      game = Slug.find_by(name: params[:game]).game
      heading = game.headings.select{|h| h.name == params[:heading]}[0]
      article = Article.new(title: params[:title], heading_id: heading.id, content: params[:content], html_content: params[:html_content])
      if article.save
        render json: {
          success: true,
          title: article.title,
          markdown: article.content,
          html: article.html_content
        }
      else
        render json: {
          success: false,
          errors: "Article Creation failed"
        }
      end
    else
      render json: {
        success: false,
        errors: "#{params[:type]} is not a supported action"
      }
    end
  end

end
