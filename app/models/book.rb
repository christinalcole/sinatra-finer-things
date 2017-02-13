class Book < ActiveRecord::Base
  validates :title, :author, presence: true

  has_many :user_books
  has_many :users, through: :user_books

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end
