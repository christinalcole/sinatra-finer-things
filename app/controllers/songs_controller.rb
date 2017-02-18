class SongsController < ApplicationController
  get '/songs' do
    if is_logged_in?
      @songs = Song.all
      erb :'songs/index'
    else
      redirect to "/login"
    end
  end

  get '/songs/new' do
    if is_logged_in?
      erb :'songs/new'
    else
      redirect to "/login"
    end
  end

  get '/songs/:slug' do
    if is_logged_in?
      @song = Song.find_by_slug(params[:slug])
      erb :'songs/show'
    else
      redirect to "/login"
    end
  end
end
