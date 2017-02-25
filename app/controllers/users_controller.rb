require 'rack-flash'
class UsersController < ApplicationController

  use Rack::Flash

  get '/users' do
    if is_logged_in?
      @users = User.all
      erb :'users/index'
    else
      redirect to "/login"
    end
  end

  get '/signup' do
    if is_logged_in?
      redirect to "/users/#{current_user.slug}"
    else
    erb :'/users/create_user'
  end
  end

  post '/signup' do
    @user = User.create(params[:user])
    if @user.valid?
      session[:user_id] = @user.id
      redirect to "/users/#{@user.slug}"
    else
      flash[:message]=@user.errors.full_messages
      redirect to "/signup"
    end
  end

  get '/login' do
    if is_logged_in?
      redirect to "/users/#{current_user.slug}"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by_name(params[:user][:name])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect to "/users/#{@user.slug}"
    else
      flash[:message]="Sorry: this user wasn't found; check your username and password."
      redirect to "/login"
    end
  end

  get '/users/:slug' do
    if is_logged_in?
      @user = User.find_by_id(session[:user_id])
      erb :'/users/show'
    else
     redirect to "/login"
    end
  end

  get '/logout' do
    if is_logged_in?
      session.clear
      redirect to "/login"
    else
      redirect to "/"
    end
  end
  
end
