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

  get '/artworks/:slug' do
    if is_logged_in?
      @artwork = Artwork.find_by_slug(params[:slug])
      erb :'artworks/show'
    else
      redirect to "/login"
    end
  end

  get '/artworks/:slug/edit' do
    if is_logged_in?
      @artworks = Artwork.all
      @artwork = Artwork.find_by_slug(params[:slug])
      if @artwork.creator_id == current_user.id
        erb :'artworks/edit'
      else
        flash[:message] = "Sorry, you can only edit artwork that you previously entered into the database"
        redirect to "/artworks/#{@artwork.slug}"
      end
    else
      redirect to "/login"
    end
  end

  patch '/artworks/:slug' do #since only a user that created the art can update it, no need to update creator_id
    @artwork = Artwork.find_by_slug(params[:slug])
    if params[:artwork][:category].nil?
      @artwork.update(name: params[:artwork][:name], artist: params[:artwork][:artist], category: params[:category])
    else
      @artwork.update(params[:artwork])
    end
    if @artwork.valid?
      flash[:message] = "This art has been successfully updated"
      redirect to "/artworks/#{@artwork.slug}"
    else
      flash[:message] = @artwork.errors.full_messages
      redirect to "/artworks/#{Artwork.find_by_slug(params[:slug]).slug}/edit"
    end
  end

  delete '/artworks/:slug/delete' do
    @artwork = Artwork.find_by_slug(params[:slug])
    if @artwork.creator_id == current_user.id
      @artwork.delete
      flash[:message] = "That art has been successfully removed from the database"
      redirect to "/artworks"
    else
      flash[:message] = "Sorry, you can only delete art from the database if you were its creator"
      redirect to "/artworks/#{@artwork.slug}"
    end
  end

  delete '/artworks/:slug/remove' do
    @artwork = Artwork.find_by_slug(params[:slug])
    current_user.artworks.delete(@artwork)
    flash[:message] = "This art has been successfully removed from your collection"
    redirect to "/users/#{current_user.slug}"
  end

end
