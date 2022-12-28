class AddUniqueIndexToFollows < ActiveRecord::Migration[7.0]
  def change
    add_index :follows, [:follower_id, :following_id], unique: true
  end
end
