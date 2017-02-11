class User < ActiveRecord::Base
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
