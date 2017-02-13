class BooksController < ApplicationController

  get '/books/new' do
    erb :'books/new'
  end

  post '/books' do
    @book = Book.create(params[:book])
    current_user.books << @book
    redirect to "/books/#{@book.slug}"
  end
  
end


# {"book"=>{"title"=>"Dwight's Book", "author"=>"Dwight's Author"},
#  "submit"=>"Add Book"}
