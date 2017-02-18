class Song < ActiveRecord::Base
  validates :name, :artist, presence: true
   
  has_many :user_songs
  has_many :users, through: :user_songs

  belongs_to :creator, :class_name => "User"

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end
