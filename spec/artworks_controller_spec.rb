require 'spec_helper'

describe ArtworksController do
  describe 'Artworks Index (Gallery) Page' do  # Allows user to see all artwork entered to database
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
end
