require 'spec_helper'

describe FeedItem do
  describe "FeedItem#nearby" do
    let(:lat) { 40.714269 }
    let(:lng) { -74.005972 }
    let(:two_miles) { 0.028}
    let(:feed_item) { FeedItem.create(lat: lat, lng: lng) }

    context "an item where the coordinates are the same" do
      it "returns the item" do
        FeedItem.nearby(lat, lng).should include(feed_item)
      end
    end

    context "an item that is two miles away in any direction" do
      it "should return the item" do
        lng_nearby= -74.003972
        FeedItem.nearby(lat, lng_nearby).should include(feed_item)
      end
    end

    context "an item is 2 miles north" do
      it "should return the item" do
        lat_nearby = 40.742260
        FeedItem.nearby(lat_nearby, lng).should include(feed_item)
      end
    end

    context "an item is more than 2 miles away negative" do
      it "should not return the item" do
        lat_nearby = 38
        FeedItem.nearby(lat_nearby, lng).should_not include(feed_item)
      end
    end
    context "an item is more than 2 miles away in the positive" do
      it "should not return the item" do
        lng_nearby = 74
        FeedItem.nearby(lat, lng_nearby).should_not include(feed_item)
      end
    end

    context "an item is on the opposite side of the world" do
      it "should not return the item" do
        lat_nearby = 74
        lng_nearby = -40
        FeedItem.nearby(lat_nearby, lng_nearby).should_not include(feed_item)
      end
    end
  end
end
