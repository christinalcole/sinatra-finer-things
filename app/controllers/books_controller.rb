class BooksController < ApplicationController

  use Rack::Flash

  get '/books' do
    if is_logged_in?
      @books = Book.all
      erb :'books/index'
    else
      redirect to "/login"
    end
  end

  get '/books/new' do
    if is_logged_in?
      erb :'books/new'
    else
      redirect to "/login"
    end
  end

  post '/books' do
    @book = Book.find_or_create_by(params[:book]) do |b| # block assigns the creator_id to the current_user if the method calls 'create'.  Otherwise, block is skipped
      b.creator_id = current_user.id
    end
    if @book.valid?
      current_user.books << @book
      redirect to "/users/#{current_user.slug}"
    else
      flash[:message] = @book.errors.full_messages
      redirect to "/books/new"
    end
  end

  get '/books/:slug' do
    if is_logged_in?
      @book = Book.find_by_slug(params[:slug])
      erb :'books/show'
    else
      redirect to "/login"
    end
  end

  get '/books/:slug/edit' do
    if is_logged_in?
      @book = Book.find_by_slug(params[:slug])
      if @book.creator_id == current_user.id
        erb :'books/edit'
      else
        flash[:message] = "Sorry: you can only edit books that you previously entered into the database"
        redirect to "/books/#{@book.slug}"
      end
    else
      redirect to "/login"
    end
  end

  patch '/books/:slug' do
    @book = Book.find_by_slug(params[:slug])
    @book.update(params[:book])
    if @book.valid?
      flash[:message] = "This book has successfully been updated in the database"
      redirect to "/books/#{@book.slug}"
    else
      flash[:message] = @book.errors.full_messages
      redirect to "/books/#{Book.find_by_slug(params[:slug]).slug}/edit"
    end
  end

  delete '/books/:slug/delete' do
    @book = Book.find_by_slug(params[:slug])
    if @book.creator_id == current_user.id
      @book.delete
      flash[:message] = "That book has been successfully removed from the database"
      redirect to "/books"
    else
      flash[:message] = "Sorry: you can only delete a book from the database if you were the first user to enter it in the database."
      redirect to "/books/#{@book.slug}"
    end
  end

  delete '/books/:slug/remove' do
    @book = Book.find_by_slug(params[:slug])
    current_user.books.delete(@book)
    flash[:message] = "That book has been successfully removed from your collection"
    redirect to "/users/#{current_user.slug}"
  end
  
end
