class BooksController < ApplicationController

  use Rack::Flash

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
      redirect to "/books/#{@book.id}"
    else
      flash[:message] = @book.errors.full_messages
      redirect to "/books/new"
    end
  end

  get '/books/:id' do # need to revise Slugifiable::slug to use generic 'name' attribute, then revise table columns
    @book = Book.find_by_id(params[:id])
    erb :'books/show'
  end

  get '/books/:id/edit' do
    if is_logged_in?
      @book = Book.find_by_id(params[:id])
      if @book.creator_id == current_user.id
        erb :'books/edit'
      else
        flash[:message] = "Sorry: you can only edit books that you previously entered into the database"
        redirect to "/books/#{@book.id}" #change this route later...
      end
    else
      redirect to "/login"
    end
  end

  patch '/books/:id' do
    @book=Book.find_by_id(params[:id])
    @book.update(params[:book])
    if @book.valid?
      flash[:message] = "This book has successfully been updated in the database"
      redirect to "/books/#{@book.id}"
    else
      flash[:message] = @book.errors.full_messages
      redirect to "/books/#{@book.id}/edit"
    end
  end
end


# {"book"=>{"title"=>"Dwight's Book", "author"=>"Dwight's Author"},
#  "submit"=>"Add Book"}
