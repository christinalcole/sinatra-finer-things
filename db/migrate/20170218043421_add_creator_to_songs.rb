class AddCreatorToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :creator_id, :integer
  end
end
