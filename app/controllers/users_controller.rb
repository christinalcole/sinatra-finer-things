class UsersController < ApplicationController

  get '/signup' do
    erb :'/users/create_user'
  end

  post '/signup' do
    @user = User.create(params["user"])
    redirect to "/users/#{@user.slug}"
  end

  get '/login' do
    erb :'/users/login'
  end

  get '/users/:slug' do
    "this is the user show page"
  end

end


#{"user"=>{"username"=>"Oscar", "password"=>"test1"}, "Sign Up"=>"Submit"}
