require 'spec_helper'

describe UsersController do
  describe "Signup Page" do  # New users signup, are logged in following signup validation, and redirect to their show page
    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'directs a signed up user to their show page' do
      visit '/signup'

      fill_in "user[name]", with: "betsy ann"
      fill_in "user[password]", with: "34rain22"
      click_on "Sign Up"

      expect(page.current_path).to eq('/users/betsy-ann')
    end

    it 'does not let a user sign up without a username' do
      visit '/signup'

      fill_in "user[name]", with: ""
      fill_in "user[password]", with: "puppy214"
      click_on "Sign Up"

      expect(page.current_path).to eq('/signup')
    end

    it 'does not let a user sign up without a password' do
      visit '/signup'

      fill_in "user[name]", with: "black magic woman"
      fill_in "user[password]", with: ""
      click_on "Sign Up"

      expect(page.current_path).to eq('/signup')
    end

    it 'does not let a logged in user view the signup page' do
      user = User.create(:name => "black magic woman", :password => "spell99")

      params = {
        "user"=>{
          :name => "black magic woman",
          :password => "spell99"}
      }

      post '/signup', params
      session = {}
      session[:id] = user.id
      get '/signup'
      expect(last_response.location).to include('/users/')
    end
  end

  describe "Login Page" do  # Existing users login, and following validatoin as an exisiting user, are redirected to their user show page
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it "loads the user's show page after login" do
      user = User.create(:name => "black magic woman", :password => "spell99")

      params = {
        "user"=>{
          :name => "black magic woman",
          :password => "spell99"}
      }

      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      #expect(last_response.body).to include("Welcome to Finer Things")
    end

    it 'does not let a logged in user see the login page' do
      user = User.create(:name => "black magic woman", :password => "spell99")

      params = {
        "user"=>{
          :name => "black magic woman",
          :password => "spell99"}
      }

      post '/login', params
      session = {}
      session[:id] = user.id
      get '/login'
      expect(last_response.location).to include('/users/')
    end
  end

  describe 'User Show Page' do  # User will be able to see all of their 'finer things', and be invited to add new items to their collection
    it 'shows all of a single users finer things' do
      user = User.create(name: "black magic woman", password: "spell99")
      user.books.concat(Book.create(name: "Title of my Favorite Book", author: "The guy who wrote it"))
      user.songs.concat([Song.create(name: "That song I like", artist: "That composer"), Song.create(name: "That other song I like", artist: "That other guy")])
      user.artworks.concat(Artwork.create(name: "My Favorite Painting", artist: "My Favorite Artist", category: "painting"))

      # Required login steps, to satisfy user show page logic
      params = {
        "user"=>{
          :name => "black magic woman",
          :password => "spell99"}
      }

      post '/login', params
      follow_redirect!

      expect(last_response.body).to include("Title of my Favorite Book")
      expect(last_response.body).to include("That song I like")
      expect(last_response.body).to include("That other guy")
      expect(last_response.body).to include("My Favorite Painting")
    end

    it 'invites a user to add a finer thing if none currently exist' do
      user = User.create(name: "betsy ann", password: "34rain22")

      params = {
        "user"=>{
          :name => "betsy ann",
          :password => "34rain22"}
      }

      post '/login', params
      follow_redirect!

      expect(last_response.body).to include("You don't have any books in your collection.")
      expect(last_response.body).to include("Add")
    end
  end

  describe 'Logout Actions' do  # User logout
    it "lets a user logout if they are already logged in" do
      user = User.create(name: "betsy ann", password: "34rain22")

      params = {
        :user =>{
          name: "betsy ann",
          password: "34rain22"
        }
      }

      post '/login', params
      get '/logout'

      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'

      expect(last_response.location).to include("/")
    end

    it 'does not load user show page if the user is not logged in' do
      user = User.create(name: "betsy ann", password: "34rain22")

      get "/users/#{user.slug}"

      expect(last_response.location).to include("/login")
    end
  end
end
