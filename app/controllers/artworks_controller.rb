class ArtworksController < ApplicationController

  get '/artworks' do
    if is_logged_in?
      @artworks = Artwork.all
      erb :'artworks/index'
    else
      redirect to "/login"
    end
  end
end
