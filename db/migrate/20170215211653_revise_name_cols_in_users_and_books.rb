class ReviseNameColsInUsersAndBooks < ActiveRecord::Migration
  def change
    rename_column :users, :username, :name
    rename_column :books, :title, :name

  end
end
