pam = User.create(name: "Pam Beesly", password: "office1")
toby = User.create(name: "Toby", password: "office2")
oscar = User.create(name: "Oscar", password: "office3")
jim = User.create(name: "Jim Halpert", password: "didn0treadAngelasAshes")

ashes = Book.create(name: "Angela's Ashes", author: "Frank McCourt", creator_id: "1")
room = Book.create(name: "A Room With A View", author: "E.M. Forester", creator_id: "2")
four_seasons = Song.create(name: "The Four Seasons", artist: "Vivaldi", creator_id: "1")
entre_dos_aguas = Song.create(name: "Entre Dos Aguas", artist: "Paco de Lucia", creator_id: "2")
toreador = Artwork.create(name: "The Hallucinogenic Toreador", artist: "Dali", category: "painting", creator_id: "2")
thorns_roses = Artwork.create(name: "The Path of Thorns and Roses", artist: "Mario Chiodo", category: "sculpture", creator_id: "3")
table_window = Artwork.create(name: "Table in Front of the Window", artist: "Picasso", category: "painting", creator_id: "4")
fish = Artwork.create(name: "Fish Mobile", artist: "Alexander Calder", category: "mobile", creator_id: "2")
mother = Artwork.create(name: "Migrant Mother", artist: "Dorthea Lange", category: "photograph", creator_id: "3")

pam.books.concat(ashes,room)
pam.songs.concat(four_seasons)
pam.artworks.concat(table_window)

toby.books.concat(room)
toby.songs.concat(entre_dos_aguas)
toby.artworks.concat(toreador,fish)

oscar.artworks.concat(thorns_roses,mother)

jim.books.concat(ashes)
jim.artworks.concat(table_window)
