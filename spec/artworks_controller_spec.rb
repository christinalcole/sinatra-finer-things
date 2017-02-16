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
end
