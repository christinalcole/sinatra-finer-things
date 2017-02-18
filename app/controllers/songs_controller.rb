class SongsController < ApplicationController
  get '/songs' do
    if is_logged_in?
      @songs = Song.all
      erb :'songs/index'
    else
      redirect to "/login"
    end
  end
end
