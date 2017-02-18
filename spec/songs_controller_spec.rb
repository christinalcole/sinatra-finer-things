require 'spec_helper'

# Since SongsController shares common desired behaviors, coding for these behaviors with BooksController, logged-in/logged-out contexts are only selectively tested

describe SongsController do
  describe 'Songs Index (Playlist) Page' do  # Allows user to see all music (songs) entered to database
    context 'logged in' do
      it 'lets a user view an index of database music if logged in' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        song1 = Song.create(name: "My Song", artist: "My Song's Artist", creator_id: user1.id)

        user2 = User.create(name: "black magic woman", password: "spell99")
        song2 = Song.create(name: "That Other Song", artist: "That Other Artist", creator_id: user2.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/songs'
        expect(page.body).to include(song1.name, song1.artist)
        expect(page.body).to include(song2.name, song2.artist)
      end
    end

    context 'logged out' do
      it 'does not allow a user to see the song index if not logged in' do
        get '/songs'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Song Show Page' do # Displays details of song object to user
    it 'displays a single song' do
      user = User.create(name: "betsy ann", password: "34rain22")
      song = Song.create(name: "My Song", artist: "My Song's Artist", creator_id: user.id)

      visit '/login'
      fill_in "user[name]", with: "betsy ann"
      fill_in "user[password]", with: "34rain22"
      click_button 'Log In'

      visit "/songs/#{song.slug}"

      expect(page.status_code).to eq(200)
      expect(page.body).to include("Delete Music")
      expect(page.body).to include(song.name, song.artist)
      expect(page.body).to include("Edit Music")
    end
  end

  describe 'Song Create Page' do # Allows logged-in user to add a new song object to the database
    context 'logged in' do
      it 'displays the new song form if a user is logged in' do
        user = User.create(name: "betsy ann", password: "34rain22")
        song = Song.create(name: "My Song", artist: "My Song's Artist", creator_id: user.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/songs/new'

        expect(page.status_code).to eq(200)
      end

      it 'lets a user create a book if logged in' do
        user = User.create(name: "betsy ann", password: "34rain22")

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/songs/new'
        fill_in "song[name]", with: "My Song"
        fill_in "song[artist]", with: "My Song's Artist"
        click_button 'Add Music'

        user = User.find_by(name: "betsy ann")
        song = Song.find_by(name: "My Song")

        expect(song).to be_instance_of(Song)
        expect(user.songs).to include(song)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user create a song object without a name or artist' do
        user = User.create(name: "betsy ann", password: "34rain22")

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/songs/new'
        fill_in "song[name]", with: ""
        fill_in "song[name]", with: "My Song's Artist"
        click_button 'Add Music'

        expect(Song.find_by(name: "")).to eq(nil)
        expect(page.current_path).to eq("/songs/new")

        visit '/songs/new'
        fill_in "song[name]", with: ""
        fill_in "song[artist]", with: ""
        click_button 'Add Music'

        expect(Song.find_by(artist: "")).to eq(nil)
        expect(page.current_path).to eq("/songs/new")
      end

      it 'does not let a user create a song object for another user' do
        user = User.create(name: "betsy ann", password: "34rain22")
        user2 = User.create(name: "black magic woman", password: "gypsy99")

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit '/songs/new'
        fill_in "song[name]", with: "My Song's Name"
        fill_in "song[artist]", with: "My Song's Artist"
        click_button 'Add Music'

        user = User.find_by_id(user.id)
        user2 = User.find_by_id(user2.id)
        song = Song.find_by(name: "My Song's Name")

        expect(song).to be_instance_of(Song)
        expect(user.songs).to include(song)
        expect(song.users).not_to eq(user2)
        expect(song.creator_id).to eq(user.id)
      end
    end

    context 'logged out' do
      it 'does not let user view new song form if not logged in' do
        get '/songs/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Song Edit Actions' do
    context 'logged in' do
      it 'lets a user view the song edit form if logged in' do
        user = User.create(name: "black magic woman", password: "spell99")
        song = Song.create(name: "My Song", artist: "My Song's Artist", creator_id: user.id)

        visit '/login'
        fill_in "user[name]", with: "black magic woman"
        fill_in "user[password]", with: "spell99"
        click_button 'Log In'

        visit "/songs/#{song.slug}/edit"

        expect(page.status_code).to eq(200)
        expect(page.body).to include(song.name, song.artist)
      end

      it 'does not let a user edit a song object that they did not create' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        song1 = Song.create(name: "My Song", artist: "My Song's Artist", creator_id: user1.id)

        user2 = User.create(name: "black magic woman", password: "spell99")
        song2 = Song.create(name: "My Other Song", artist: "My Other Song's Artist", creator_id: user2.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'
        session = {}
        session[:user_id] = user1.id

        visit "/songs/#{song2.slug}/edit"

        expect(page.current_path).to eq("/songs/#{song2.slug}")
      end

      it 'lets a user edit a song object that they created if they are logged in' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        song1 = Song.create(name: "My Song", artist: "My Song's Artist", creator_id: user1.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit "/songs/#{song1.slug}/edit"
        fill_in "song[artist]", with: "My Song's Other Artist"
        click_button 'Edit Music'

        expect(Song.find_by(artist: "My Song's Other Artist")).to be_instance_of(Song)
        expect(Song.find_by(artist: "My Song's Artist")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a song object to have blank content' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        song1 = Song.create(name: "My Song", artist: "My Song's Artist", creator_id: user1.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit "/songs/#{song1.slug}/edit"
        fill_in "song[name]", with: ""
        click_button 'Edit Music'

        song1 = Song.find_by_id(1)
        expect(Song.find_by(name: "")).to be(nil)
        expect(page.current_path).to eq("/songs/#{song1.slug}/edit")
      end
    end

    context "logged out" do
      it 'does not let user view song edit form if not logged in' do
        get '/songs/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'Song Delete Actions' do
    context "logged in" do
      it 'lets a user delete a song object of their creation if logged in' do
        user = User.create(name: "betsy ann", password: "34rain22")
        song = Song.create(name: "My Song", artist: "My Song's Artist", creator_id: user.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit "/songs/#{song.slug}"
        click_button 'Delete Song'

        expect(page.status_code).to eq(200)
        expect(Song.find_by(name: "My Song")).to eq(nil)
      end

      it 'does not let a user delete a song object they did not create' do
        user1 = User.create(name: "betsy ann", password: "34rain22")
        song1 = Song.create(name: "My Song", artist: "My Song's Artist", creator_id: user1.id)

        user2 = User.create(name: "black magic woman", password: "spell99")
        song2 = Song.create(name: "My Other Song", artist: "That Other Artist", creator_id: user2.id)

        visit '/login'
        fill_in "user[name]", with: "betsy ann"
        fill_in "user[password]", with: "34rain22"
        click_button 'Log In'

        visit "/songs/#{song2.slug}"
        click_button 'Delete Song'

        expect(page.status_code).to eq(200)
        expect(Song.find_by(name: "My Other Song")).to be_instance_of(Song)
        expect(page.current_path).to eq("/songs/#{song2.slug}")
      end
    end
  end

  describe 'Song Remove Actions' do
    it 'lets a user remove a song object from their collection' do
      user = User.create(name: "betsy ann", password: "34rain22")
      song = Song.create(name: "My Song", artist: "My Song's Artist", creator_id: user.id)
      user.songs << song

      visit '/login'
      fill_in "user[name]", with: "betsy ann"
      fill_in "user[password]", with: "34rain22"
      click_button 'Log In'

      visit "/users/#{user.slug}"
      click_button 'remove music from collection'

      user = User.find_by(name: "betsy ann")
      song = Song.find_by(name: "My Song")

      expect(user.songs).to_not include(song)
    end

    it 'does not delete the removed song from the database' do
      user = User.create(name: "betsy ann", password: "34rain22")
      song = Song.create(name: "My Song", artist: "My Song's Artist", creator_id: user.id)
      user.songs << song

      visit '/login'
      fill_in "user[name]", with: "betsy ann"
      fill_in "user[password]", with: "34rain22"
      click_button 'Log In'

      visit "/users/#{user.slug}"
      click_button 'remove music from collection'

      expect(Song.all).to include(song)
    end
  end

end
