class ArtworksController < ApplicationController
  get '/artworks' do
    @artworks = Artwork.all
    erb :'artworks/index'
  end
end
