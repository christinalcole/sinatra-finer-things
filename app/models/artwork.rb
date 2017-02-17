class Artwork < ActiveRecord::Base
  has_many :user_artworks
  has_many :users, through: :user_artworks

  belongs_to :creator, :class_name => "User"

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

  def self.categories
    self.all.collect do |art|
      art.category
    end.uniq
  end
end
