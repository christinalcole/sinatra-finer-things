require 'spec_helper'

# Since ArtworksController shares common desired behaviors, coding for these behaviors with BooksController, logged-in/logged-out contexts are only selectively tested

describe ArtworksController do
  describe 'Artworks Index (Gallery) Page' do  # Allows user to see all artwork entered to database
    context 'logged in' do
      it 'lets a user view an index of database artwork if logged in' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        artwork1 = Artwork.create(name: "The Ship", artist: "Salvador Dali", category: "painting", creator_id: user1.id)

        user2 = User.create(name: "black magic woman", password: "spell99")
        artwork2 = Artwork.create(name: "The Kiss", artist: "Rodin", category: "sculpture", creator_id: user2.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/artworks'
        expect(page.body).to include(artwork1.name, artwork1.artist, artwork1.category)
        expect(page.body).to include(artwork2.name, artwork2.artist, artwork2.category)
      end
    end

    context 'logged out' do
      it 'does not allow a user to see the artwork index if not logged in' do
        get '/artworks'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Artwork Show Page' do # Displays details of artwork object to user
    it 'displays a single artwork' do
      user = User.create(name: "betsy ann", password: "34rain22")
      artwork = Artwork.create(name: "The Ship", artist: "Salvador Dali", category: "painting", creator_id: user.id)

      visit '/login'
      fill_in "user[name]", with: "betsy ann"
      fill_in "user[password]", with: "34rain22"
      click_button 'Log In'

      visit "/artworks/#{artwork.slug}"

      expect(page.status_code).to eq(200)
      expect(page.body).to include("Delete Artwork")
      expect(page.body).to include(artwork.name, artwork.artist, artwork.category)
      expect(page.body).to include("Edit Artwork")
    end
  end

  describe 'Artwork Create Page' do # Allows logged-in user to add a new artwork object to the database
    context 'logged in' do
      it 'displays the new artwork form if a user is logged in' do
        user = User.create(name: "betsy ann", password: "34rain22")
        artwork = Artwork.create(name: "The Ship", artist: "Salvador Dali", category: "painting", creator_id: user.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/artworks/new'

        expect(page.status_code).to eq(200)
      end

      it 'lets a user create a book if logged in' do
        user = User.create(name: "betsy ann", password: "34rain22")

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/artworks/new'
        fill_in "artwork[name]", with: "My Mobile"
        fill_in "artwork[artist]", with: "My Mobile's Artist"
        fill_in "category", with: "mobile"
        click_button 'Add Art'

        user = User.find_by(name: "betsy ann")
        artwork = Artwork.find_by(name: "My Mobile")

        expect(artwork).to be_instance_of(Artwork)
        expect(user.artworks).to include(artwork)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user create art without a name, artist, or category' do
        user = User.create(name: "betsy ann", password: "34rain22")

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/artworks/new'
        fill_in "artwork[name]", with: ""
        fill_in "artwork[name]", with: "My art's Artist"
        fill_in "category", with: ""
        click_button 'Add Art'

        expect(Artwork.find_by(name: "")).to eq(nil)
        expect(Artwork.find_by(category: "")).to eq(nil)
        expect(page.current_path).to eq("/artworks/new")

        visit '/artworks/new'
        fill_in "artwork[name]", with: ""
        fill_in "artwork[artist]", with: ""
        fill_in "category", with: "fingerpainting"
        click_button 'Add Art'

        expect(Artwork.find_by(artist: "")).to eq(nil)
        expect(page.current_path).to eq("/artworks/new")
      end

      it 'does not let a user create art for another user' do
        user = User.create(name: "betsy ann", password: "34rain22")
        user2 = User.create(name: "black magic woman", password: "gypsy99")

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/artworks/new'
        fill_in "artwork[name]", with: "My Art's Title"
        fill_in "artwork[artist]", with: "My art's Artist"
        fill_in "category", with: "fingerpainting"
        click_button 'Add Art'

        user = User.find_by_id(user.id)
        user2 = User.find_by_id(user2.id)
        art = Artwork.find_by(name: "My Art's Title")

        expect(art).to be_instance_of(Artwork)
        expect(user.artworks).to include(art)
        expect(art.users).not_to eq(user2)
        expect(art.creator_id).to eq(user.id)
      end
    end

    context 'logged out' do
      it 'does not let user view new artwork form if not logged in' do
        get '/artworks/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Artwork Edit Actions' do
    context 'logged in' do
      it 'lets a user view the artwork edit form if logged in' do
        user = User.create(name: "black magic woman", password: "spell99")
        artwork = Artwork.create(name: "The Ship", artist: "Salvador Dali", category: "painting", creator_id: user.id)

        visit '/login'
        fill_in "user[name]", with: "black magic woman"
        fill_in "user[password]", with: "spell99"
        click_button 'Log In'

        visit "/artworks/#{artwork.slug}/edit"

        expect(page.status_code).to eq(200)
        expect(page.body).to include(artwork.name, artwork.artist, artwork.category)
      end

      it 'does not let a user edit art that they did not create' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        artwork1 = Artwork.create(name: "My Art", artist: "My Art's Artist", category: "painting", creator_id: user1.id)

        user2 = User.create(name: "black magic woman", password: "spell99")
        artwork2 = Artwork.create(name: "The Ship", artist: "Salvador Dali", category: "painting", creator_id: user2.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'
        session = {}
        session[:user_id] = user1.id

        visit "/artworks/#{artwork2.slug}/edit"

        expect(page.current_path).to eq("/artworks/#{artwork2.slug}")
      end

      it 'lets a user edit art that they created if they are logged in' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        artwork1 = Artwork.create(name: "My Art", artist: "My Art's Artist", category: "painting", creator_id: user1.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit "/artworks/#{artwork1.slug}/edit"
        fill_in "artwork[artist]", with: "My Art's Other Artist"
        click_button 'Edit Art'

        expect(Artwork.find_by(artist: "My Art's Other Artist")).to be_instance_of(Artwork)
        expect(Artwork.find_by(artist: "My Art's Artist")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit art to have blank content' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        artwork1 = Artwork.create(name: "My Art", artist: "My Art's Artist", category: "painting", creator_id: user1.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit "/artworks/#{artwork1.slug}/edit"
        fill_in "artwork[name]", with: ""
        click_button 'Edit Art'

        artwork1 = Artwork.find_by_id(1)
        expect(Artwork.find_by(name: "")).to be(nil)
        expect(page.current_path).to eq("/artworks/#{artwork1.slug}/edit")
      end
    end

    context "logged out" do
      it 'does not let user view artwork edit form if not logged in' do
        get '/artworks/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end
end
