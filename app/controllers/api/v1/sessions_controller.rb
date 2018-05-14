class Api::V1::SessionsController < ApplicationController
  # def index
  #   puts("*********")
  #   puts session
  #   if session[:current_user_id]
  #     user = User.find(session[:current_user_id])
  #     render json: {
  #       loggedIn: true,
  #       username: user
  #     }
  #   else
  #     render json: {
  #       loggedIn: false,
  #       username: ""
  #     }
  #   end
  # end
end
