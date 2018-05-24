class Api::V1::ArticlesController < ApplicationController
  def create
    if params[:type] == "getArticle"
      puts params
      slug = Slug.find_by(name: params[:game])
      whosAsking = User.find_by(username: params[:username])
      if slug
        game = slug.game
        moderator = false
        if whosAsking && whosAsking.games.include?(game)
          moderator = true
        end
        article = game.articles.select{|a| a.title.downcase == params[:article].downcase}[0]
        edit = article.latestApprovedEdit || article
        articles = game.headings.map{|h| h.articles}
        approved_edits = article.approvedEdits || [article]
        all_edits = article.editsSorted || [article]
      end
      if edit
        render json: {
          success: true,
          markdown: edit.content,
          html: edit.html_content,
          title: edit.title,
          approvedEdits: approved_edits,
          all_edits: all_edits,
          headings: game.headings,
          articles: articles,
          game: game,
          moderator: moderator
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
      status = params[:moderator] ? "approved" : "pending"
      newEdit = Edit.new(article_id: article.id, title: params[:title], html_content: params[:html_content], content: params[:content], status: status)
      if newEdit.save
        puts newEdit
        article = article.latestApprovedEdit || article
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
      status = params[:moderator] ? "approved" : "pending"
      article = Article.new(title: params[:title], heading_id: heading.id, content: params[:content], html_content: params[:html_content])
      article.save
      newEdit = Edit.new(article_id: article.id, title: params[:title], html_content: params[:html_content], content: params[:content], status: "status")
      if newEdit.save
        article = article.latestApprovedEdit || article
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

  def update
    edit = Edit.find(params[:id])
    edit.status = params[:type]
    edit.save
    render json: {
      edit: edit
    }
  end
end
