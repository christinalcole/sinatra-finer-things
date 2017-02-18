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

  post '/songs' do
    @song = Song.find_or_create_by(params[:song]) do |s|
      s.creator_id = current_user.id
    end
    if @song.valid?
      current_user.songs << @song
      redirect to "/users/#{current_user.slug}"
    else
      flash[:message] = @song.errors.full_messages
      redirect to "/songs/new"
    end
  end

  get '/songs/:slug/edit' do
    if is_logged_in?
      @song = Song.find_by_slug(params[:slug])
      if @song.creator_id == current_user.id
        erb :'songs/edit'
      else
        flash[:message] = "Sorry, you can only edit music that you previously entered into the database"
        redirect to "/songs/#{@song.slug}"
      end
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

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @song.update(params[:song])
    if @song.valid?
      flash[:message] = "This music has been successfully updated"
      redirect to "/songs/#{@song.slug}"
    else
      flash[:message] = @song.errors.full_messages
      redirect to "/songs/#{Song.find_by_slug(params[:slug]).slug}/edit"
    end
  end
end
