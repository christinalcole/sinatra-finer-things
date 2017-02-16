require 'spec_helper'

describe BooksController do
  describe 'Book Create Page' do # User will be able to create a new 'finer book'; when saved to the database, the book is added to the user's collection
    context 'logged in' do
      it 'lets a user view new book form if logged in' do
        user = User.create(name: "betsy ann", password: "34rain22")

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/books/new'

        expect(page.status_code).to eq(200)
      end

      it 'lets a user create a book if logged in' do
        user = User.create(name: "betsy ann", password: "34rain22")

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/books/new'
        fill_in "book[name]", with: "My Book"
        fill_in "book[author]", with: "My book's Author"
        click_button 'Add Book'

        user = User.find_by(name: "betsy ann")
        book = Book.find_by(name: "My Book")

        expect(book).to be_instance_of(Book)
        expect(user.books).to include(book)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user create a book without a name or author' do
        user = User.create(name: "betsy ann", password: "34rain22")

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/books/new'
        fill_in "book[name]", with: ""
        fill_in "book[author]", with: "My book's Author"
        click_button 'Add Book'

        expect(Book.find_by(name: "")).to eq(nil)
        expect(page.current_path).to eq("/books/new")

        visit '/books/new'
        fill_in "book[name]", with: "My Book's Title"
        fill_in "book[author]", with: ""
        click_button 'Add Book'

        expect(Book.find_by(author: "")).to eq(nil)
        expect(page.current_path).to eq("/books/new")
      end

      it 'does not let a user create a book for another user' do
        user = User.create(name: "betsy ann", password: "34rain22")
        user2 = User.create(name: "black magic woman", password: "gypsy99")

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/books/new'
        fill_in "book[name]", with: "My Book's Title"
        fill_in "book[author]", with: "My book's Author"
        click_button 'Add Book'

        user = User.find_by_id(user.id)
        user2 = User.find_by_id(user2.id)
        book = Book.find_by(name: "My Book's Title")

        expect(book).to be_instance_of(Book)
        expect(user.books).to include(book)
        expect(book.users).not_to eq(user2)
        expect(book.creator_id).to eq(user.id)
      end
    end

    context 'logged out' do
      it 'does not let user view new book form if not logged in' do
        get '/books/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Book Index Page' do # Allows user to see a list of all books in the database
    context 'logged in' do
      it 'lets a user view the books index if logged in' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        book1 = Book.create(name: "My Book", author: "My Book's Author", creator_id: user1.id)

        user2 = User.create(name: "black magic woman", password: "spell99")
        book2 = Book.create(name: "My Other Book", author: "That Other Author", creator_id: user2.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/books'

        expect(page.body).to include(book1.name, book1.author)
        expect(page.body).to include(book2.name, book2.author)
      end
    end

    context 'logged out' do
      it 'does not let a user view the books index if not logged in' do
        get '/books'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Book Show Actions' do  # User can see details for a specific book
    context 'logged in' do
      it 'displays a single book' do
        user = User.create(name: "betsy ann", password: "34rain22")
        book = Book.create(name: "My Book", author: "My author")

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit "/books/#{book.slug}"

        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete Book")
        expect(page.body).to include(book.name, book.author)
        expect(page.body).to include("Edit Book")
      end
    end

    context 'logged out' do
      it 'does not let a user view a book' do
        user = User.create(name: "betsy ann", password: "34rain22")
        book = Book.create(name: "My Book", author: "My author")

        get "/books/#{book.slug}"

        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Book Edit Actions' do  # User will be able to edit a book's attributes, but only if the book was initially created by the user
    context 'logged in' do
      it 'lets a user view the book edit form if logged in' do
        user = User.create(name: "black magic woman", password: "spell99")
        book = Book.create(name: "My Favorite Book", author: "My Favorite Author")
        user.books << book

        visit '/login'
        fill_in "user[name]", with: "black magic woman"
        fill_in "user[password]", with: "spell99"
        click_button 'Log In'

        visit "/books/#{book.slug}/edit"

        expect(page.status_code).to eq(200)
        expect(page.body).to include(book.name, book.author)
      end

      it 'does not let a user edit a book that they did not create' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        book1 = Book.create(name: "My Book", author: "My Book's Author", creator_id: user1.id)

        user2 = User.create(name: "black magic woman", password: "spell99")
        book2 = Book.create(name: "My Other Book", author: "That Other Author", creator_id: user2.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'
        session = {}
        session[:user_id] = user1.id

        visit "/books/#{book2.slug}/edit"

        expect(page.current_path).to eq("/books/#{book2.slug}")
      end

      it 'lets a user edit a book that they created if they are logged in' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        book1 = Book.create(name: "My Book", author: "My Book's Author", creator_id: user1.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit "/books/#{book1.slug}/edit"
        fill_in "book[author]", with: "My Book's Other Author"
        click_button 'Edit Book'

        expect(Book.find_by(author: "My Book's Other Author")).to be_instance_of(Book)
        expect(Book.find_by(author: "My Book's Author")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a book with blank content' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        book1 = Book.create(name: "My Book", author: "My Book's Author", creator_id: user1.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit "/books/#{book1.slug}/edit"
        fill_in "book[name]", with: ""
        click_button 'Edit Book'

        expect(Book.find_by(name: "")).to be(nil)
        expect(page.current_path).to eq("/books/#{book1.slug}/edit")
      end
    end

    context "logged out" do
      it 'does not let user view book edit form if not logged in' do
        get '/books/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Book Delete Actions' do  # User can delete a book, but only if the book was initially added to the database by that user
    context "logged in" do
      it 'lets a user delete a book of their creation if logged in' do
        user = User.create(name: "betsy ann", password: "34rain22")
        book = Book.create(name: "My Book", author: "My Book's Author", creator_id: user.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit "/books/#{book.slug}"
        click_button 'Delete Book'

        expect(page.status_code).to eq(200)
        expect(Book.find_by(name: "My Book")).to eq(nil)
      end

      it 'does not let a user delete a book they did not create' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        book1 = Book.create(name: "My Book", author: "My Book's Author", creator_id: user1.id)

        user2 = User.create(name: "black magic woman", password: "spell99")
        book2 = Book.create(name: "My Other Book", author: "That Other Author", creator_id: user2.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit "/books/#{book2.slug}"
        click_button 'Delete Book'

        expect(page.status_code).to eq(200)
        expect(Book.find_by(name: "My Other Book")).to be_instance_of(Book)
        expect(page.current_path).to eq("/books/#{book2.slug}")
      end
    end

    context "logged out" do
      it 'does not let a user delete a book if not logged in' do
        book = Book.create(name: "My Book", author: "My Book's Author", creator_id: 1)

        visit '/books/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end

  describe 'Book Remove Actions' do  # Allows a user to remove a book from the user's collection without removing the book from the database
    it 'lets a user remove a book from their collection' do
      user = User.create(name: "betsy ann", password: "34rain22")
      book = Book.create(name: "My Book", author: "My Book's Author", creator_id: user.id)
      user.books << book

      visit '/login'
      fill_in "user[name]", with: "betsy ann"
      fill_in "user[password]", with: "34rain22"
      click_button 'Log In'

      visit "/users/#{user.slug}"
      click_button 'remove book from collection'

      user = User.find_by(name: "betsy ann")
      book = Book.find_by(name: "My Book")

      expect(user.books).to_not include(book)
    end

    it 'does not delete the removed book from the database' do
      user = User.create(name: "betsy ann", password: "34rain22")
      book = Book.create(name: "My Book", author: "My Book's Author", creator_id: user.id)
      user.books << book

      visit '/login'
      fill_in "user[name]", with: "betsy ann"
      fill_in "user[password]", with: "34rain22"
      click_button 'Log In'

      visit "/users/#{user.slug}"
      click_button 'remove book from collection'

      expect(Book.all).to include(book)
    end
  end
end
