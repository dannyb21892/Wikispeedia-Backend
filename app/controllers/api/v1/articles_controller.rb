class Api::V1::ArticlesController < ApplicationController
  def create
    if params[:type] == "getArticle"
      game = Slug.find_by(name: params[:game]).game
      article = game.articles.select{|a| a.title.downcase == params[:article].downcase}[0]
      if article
        render json: {
          success: true,
          markdown: article.content,
          html: article.html_content
        }
      else
        render json: {
          success: false,
          errors: "No article by that name found for #{game.title}"
        }
      end
    elsif params[:type] == "updateArticle"
      game = Slug.find_by(name: params[:game]).game
      article = game.articles.select{|a| a.title.downcase == params[:article].downcase}[0]

      article.content = params[:content]
      article.html_content = params[:html_content]
      if article.save
        render json: {
          success: true,
          markdown: article.content,
          html: article.html_content
        }
      else
        render json: {
          success: false,
          errors: "Edit failed"
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
