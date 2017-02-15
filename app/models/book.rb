class Book < ActiveRecord::Base
  validates :name, :author, presence: true

  has_many :user_books
  has_many :users, through: :user_books

  belongs_to :creator, :class_name => "User"

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end
