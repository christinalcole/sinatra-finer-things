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

  post '/artworks' do
    if params[:category].empty? # assumes an exisiting object won't require a user to create a new category
      @artwork = Artwork.find_or_create_by(params[:artwork]) do |a|
        a.creator_id = current_user.id
      end
    else
      @artwork = Artwork.create(name: params[:artwork][:name], artist: params[:artwork][:artist], category: params[:category], creator_id: current_user.id)
    end
    if @artwork.valid?
      current_user.artworks << @artwork
      redirect to "/users/#{current_user.slug}"
    else
      flash[:message] = @artwork.errors.full_messages
      redirect to "/artworks/new"
    end
  end

  # {"artwork"=>
  #   {"name"=>"Table in Front of the Window",
  #    "artist"=>"Picasso",
  #    "category"=>"painting"},
  #  "category"=>"",
  #  "submit"=>"Add Art"}

  get '/artworks/:slug' do
    if is_logged_in?
      @artwork = Artwork.find_by_slug(params[:slug])
      erb :'artworks/show'
    else
      redirect to "/login"
    end
  end


end
