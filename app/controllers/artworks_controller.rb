class ArtworksController < ApplicationController

  get '/artworks' do
    if is_logged_in?
      @artworks = Artwork.all
      erb :'artworks/index'
    else
      redirect to "/login"
    end
  end

  get '/artworks/new' do
    if is_logged_in?
      @artworks = Artwork.all
      erb :'artworks/new'
    else
      redirect to "/login"
    end
  end

  get '/artworks/:slug' do
    if is_logged_in?
      @artwork = Artwork.find_by_slug(params[:slug])
      erb :'artworks/show'
    else
      redirect to "/login"
    end
  end


end
