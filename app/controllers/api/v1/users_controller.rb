class Api::V1::UsersController < ApplicationController
  def create
    if params[:type] == "login"
      login(params)
    elsif params[:type] == "signup"
      signup(params)
    elsif params[:type] == "checkUser"
      user = User.find_by(username: params[:username])
      username = user ? user.username : nil
      render json: {
        userExists: !!user,
        username: username
      }
    elsif params[:type] == "checkNotifications"
      out = User.find_by(username: params[:username]).notifications
      render json: {
        notifications: out
      }
    else
      render json: {
        loggedIn: false,
        errors: "No request type matches '#{params[:type]}'"
      }
    end
  end

  def login(params)
    user = User.find_by(username: params[:username])
    if user
      auth = user.authenticate(params[:password]) || (user.password_digest == params[:pd])
      render json: {
        logged_in: !!auth,
        auth: user.password_digest,
        errors: !!auth ? nil : "Incorrect Password for #{params[:username]}"
      }
    else
      render json: {
        logged_in: false,
        errors: "No user found with username '#{params[:username]}'"
      }
    end
  end

  def signup(params)
    user = User.find_by(username: params[:username])
    if user
      render json: {
        logged_in: false,
        errors: "User already exists with username '#{params[:username]}'"
      }
    else
      user = User.new(username: params[:username], password: params[:password])
      if user.save
        render json: {
          logged_in: true,
          auth: user.password_digest,
          errors: ""
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
