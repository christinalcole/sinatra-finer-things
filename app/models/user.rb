class User < ActiveRecord::Base
  validates :name, :password, presence: true
  validates :name, exclusion: {in: ["Andy Bernard"], message: "...Nope...you still can't join the Finer Things Club, Andy"}
  has_secure_password

  has_many :user_books
  has_many :books, through: :user_books

  has_many :user_artworks
  has_many :artworks, through: :user_artworks

  has_many :user_songs
  has_many :songs, through: :user_songs

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end
