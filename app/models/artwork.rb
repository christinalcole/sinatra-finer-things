class Artwork < ActiveRecord::Base
  has_many :user_artworks
  has_many :users, through: :user_artworks
end
