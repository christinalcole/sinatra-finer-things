class AddCreatorToArtworks < ActiveRecord::Migration
  def change
      add_column :artworks, :creator_id, :integer
  end
end
