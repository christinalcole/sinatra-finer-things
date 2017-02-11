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

end
