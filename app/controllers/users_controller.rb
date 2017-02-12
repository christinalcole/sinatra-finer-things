require 'rack-flash'
class UsersController < ApplicationController

  use Rack::Flash

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
    @user = User.find_by_username(params[:user][:username])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect to "/users/#{@user.slug}"
    else
      flash[:message]="Sorry: this user wasn't found; check your username and password."
      redirect to "/login"
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/show'
  end

  get '/logout' do
    session.clear
  end

end


#{"user"=>{"username"=>"Oscar", "password"=>"test1"}, "Sign Up"=>"Submit"}
