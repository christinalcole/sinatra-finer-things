class User < ActiveRecord::Base
  validates :username, :password, presence: true
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
