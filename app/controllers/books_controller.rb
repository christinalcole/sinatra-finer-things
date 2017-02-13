class BooksController < ApplicationController

  use Rack::Flash

  get '/books/new' do
    erb :'books/new'
  end

  post '/books' do
    @book = Book.create(params[:book])
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
end


# {"book"=>{"title"=>"Dwight's Book", "author"=>"Dwight's Author"},
#  "submit"=>"Add Book"}
