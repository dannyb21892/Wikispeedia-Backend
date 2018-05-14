class Api::V1::UsersController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    if user
      auth = user.authenticate(params[:password])
      # if auth
      #   session[:current_user_id] = user.id
      #   puts session
      # end
      render json: {
        logged_in: !!auth,
        errors: !!auth ? nil : "Incorrect Password for #{params[:username]}"
      }
    else
      user = User.new(username: params[:username], password: params[:password])
      if user.save
        # session[:current_user_id] = user.id
        # puts session
        render json: {
          logged_in: true,
          user: user.username
        }
      else
        render json: {
          logged_in: false,
          errors: user.errors.full_messages
        }
      end
    end
  end
end
