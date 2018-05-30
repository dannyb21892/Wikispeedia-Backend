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
      user = User.find_by(username: params[:username])
      out = user ? user.notifications : []
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
      if params[:username].split("").select{|a| "1234567890-_qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM".include?(a)}.join("") == params[:username]
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
      else
        render json: {
          logged_in: false,
          errors: "Username contains invalid characters. Stick to alphanumeric characters, dashes and underscores."
        }
      end
    end
  end

  def destroy
    user = User.find_by(username: params[:id])
    if user.destroy
      render json: {
        success: true
      }
    else
      render json: {
        success: false
      }
    end
  end
end
