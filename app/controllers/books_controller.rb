class BooksController < ApplicationController

  get '/books/new' do
    erb :'books/new'
  end

  post '/books' do
    @book = Book.create(params[:book])
    current_user.books << @book
    redirect to "/books/#{@book.id}"
  end

  get '/books/:id' do # need to revise Slugifiable::slug to use generic 'name' attribute, then revise table columns
    @book = Book.find_by_id(params[:id])
    erb :'books/show'
  end
end


# {"book"=>{"title"=>"Dwight's Book", "author"=>"Dwight's Author"},
#  "submit"=>"Add Book"}
