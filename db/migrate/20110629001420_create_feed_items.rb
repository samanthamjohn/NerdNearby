class CreateFeedItems < ActiveRecord::Migration
  def self.up
    create_table :feed_items do |t|
      t.string  :feed_item_type
      t.string  :type_id
      t.string  :url
      t.string  :text
      t.string  :user
      t.string  :image_tag
      t.float   :lat
      t.float   :lng
      t.time    :post_time
      t.string  :name
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_items
  end
end
