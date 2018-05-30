class Api::V1::ArticlesController < ApplicationController
  def create
    if params[:type] == "getArticle"
      slug = Slug.find_by(name: params[:game])
      whosAsking = User.find_by(username: params[:username])
      if slug
        game = slug.game
        moderator = false
        follower = false
        if whosAsking && whosAsking.games.include?(game)
          moderator = true
          follower = !!whosAsking.followers.select{|f| f.game == game}[0]
        end
        home = false
        if params[:article].downcase === "home"
          article = game.home
          if article
            edit = article.latestApprovedEdit || article
            approved_edits = article.approvedEdits || [article]
            all_edits = article.editsSorted || [article]
            heading = ""
            html = edit.html_content
            home = true
          end
        else
          article = game.articles.select{|a| a.article_slug.name.downcase == params[:article].downcase}[0]
          if article
            edit = article.latestApprovedEdit || article
            approved_edits = article.approvedEdits || [article]
            all_edits = article.editsSorted || [article]
            heading = article.heading.name
            html = edit.html_content
          end
        end
        articles = game.headings.map{|h| h.articles}
      end
      if edit
        render json: {
          success: true,
          markdown: edit.content,
          html: html,
          title: edit.title,
          approvedEdits: approved_edits,
          all_edits: all_edits,
          headings: game.headings,
          heading: heading,
          articles: articles,
          game: game,
          moderator: moderator,
          follower: follower,
          home: home
        }
      else
        render json: {
          success: false,
          errors: "No article by that name found",
          headings: game.headings,
          articles: articles,
          game: game,
          moderator: moderator,
          follower: follower
        }
      end
    elsif params[:type] == "updateArticle"
      game = Slug.find_by(name: params[:game]).game
      creator = User.find_by(username: params[:user])
      if params[:home]
        article = game.home
        status = params[:moderator] ? "approved" : "pending"
        newEdit = HomeEdit.new(home_id: article.id, title: params[:title], html_content: params[:html_content], content: params[:content], status: status, user_id: creator.id)
        slug = "home"
        if newEdit.save
          puts newEdit
          article = article.latestApprovedEdit || article
          render json: {
            success: true,
            markdown: article.content,
            html: article.html_content,
            title: article.title,
            slug: slug
          }
        else
          render json: {
            success: false,
            errors: "Edit failed"
          }
        end
      else
        article = game.articles.select{|a| a.title.downcase == params[:title].downcase}[0]
        status = params[:moderator] ? "approved" : "pending"
        newEdit = Edit.new(article_id: article.id, title: params[:title], html_content: params[:html_content], content: params[:content], status: status, user_id: creator.id)
        slug = article.article_slug.name
        if newEdit.save
          puts newEdit
          article = article.latestApprovedEdit || article
          render json: {
            success: true,
            markdown: article.content,
            html: article.html_content,
            title: article.title,
            slug: slug
          }
        else
          render json: {
            success: false,
            errors: "Edit failed"
          }
        end
      end
    elsif params[:type] == "newArticle"
      game = Slug.find_by(name: params[:game]).game
      creator = User.find_by(username: params[:user])
      heading = game.headings.select{|h| h.name == params[:heading]}[0]
      status = params[:moderator] ? "approved" : "pending"
      if params[:title] == "home"
        article = Home.new(title: params[:title], game_id: game.id, content: params[:content], html_content: params[:html_content])
        article.save
        newEdit = HomeEdit.new(home_id: article.id, title: params[:title], html_content: params[:html_content], content: params[:content], status: "approved", user_id: creator.id)
      else
        article = Article.new(title: params[:title], heading_id: heading.id, content: params[:content], html_content: params[:html_content])
        article.save
        slug = ArticleSlug.create(article_id: article.id, name: params[:slug])
        newEdit = Edit.new(article_id: article.id, title: params[:title], html_content: params[:html_content], content: params[:content], status: "approved", user_id: creator.id)
      end
      if newEdit.save
        article = article.latestApprovedEdit || article
        render json: {
          success: true,
          title: article.title,
          markdown: article.content,
          html: article.html_content,
          slug: slug.name
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
