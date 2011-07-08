class AddLikesToFeedItems < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :likes, :integer
  end

  def self.down
    remove_column :feed_items, :likes
  end
end
