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
    erb :'/users/login'
  end

  get '/users/:slug' do
    "this is the user show page"
  end

  get '/logout' do
    session.clear
  end

end


#{"user"=>{"username"=>"Oscar", "password"=>"test1"}, "Sign Up"=>"Submit"}
