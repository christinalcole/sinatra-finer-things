class AddCreatorToBooks < ActiveRecord::Migration
  def change
    add_column :books, :creator_id, :integer
  end
end
