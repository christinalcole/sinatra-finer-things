require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "i'll_never_tell"
  end

  get '/' do  # FinerThingsClub landing page
    erb :index
  end

  helpers do
    def current_user
      @user ||= User.find(session[:user_id]) if session[:user_id] != nil
    end

    def is_logged_in?
      !!current_user
    end
  end

end
