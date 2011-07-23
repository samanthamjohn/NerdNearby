require 'spec_helper'

describe FeedItem do
  describe "#twitter_nearby" do
    it "should call twitter" do
      lat,lng = 1,2

      Net::HTTP.should_receive(:get).with(URI.parse("http://search.twitter.com/search.json?geocode=1,2,1mi")).and_return('{"results": []}')
      FeedItem.twitter_nearby(lat,lng).should == []
    end

    it "should return FeedItems" do
      lat,lng = 1,2
      tweet = {}
      tweet["text"] = "I'm eating a sandwich"
      tweet["from_user"] = "evan_farrar"
      tweet["id"] = "1112223334"
      tweet["created_at"] = time = Time.now.to_s
      tweet["profile_image_url"] = 'http://example.com/evan_normal.jpg'
      response = {results: [ tweet ]}
      Net::HTTP.should_receive(:get).with(URI.parse("http://search.twitter.com/search.json?geocode=1,2,1mi")).and_return(response.to_json)
      item = FeedItem.twitter_nearby(lat,lng).first
      item.type_id.should == tweet["id"]
      item.post_time.should == Time.parse(time)
      item.image_tag.should == "http://example.com/evan_reasonably_small.jpg"
      item.text.should == tweet["text"]
      item.user.should == tweet["from_user"]
      item.url.should == "http://twitter.com/#{tweet["from_user"]}/status/#{tweet["id"]}"
      item.feed_item_type.should == "tweet"
    end
  end
 #describe "#nearby" do

 #  describe "#flickr_nearby" do
 #    it "should return only 20 photos" do
 #      FlickRaw.stubs(:url).returns("url.com")
 #      FlickRaw.stubs(:url_m).returns("url.com")
 #      FlickRaw.stubs(:url_short).returns("short_url.com")
 #      one_hundred_photos = []
 #      50.times do
 #        one_hundred_photos.push(stub(id: 3, title: "my cool photo"))
 #      end
 #      stub_photos = stub(:stub_photos)
 #      stub_photos.expects(:search).returns(one_hundred_photos)
 #      stub_flickr = stub(:flickr_stub)
 #      stub_flickr.stubs(:photos).returns(stub_photos)
 #      controller.stubs(:flickr).returns(stub_flickr)

 #      get :index

 #      feed_items = assigns(:feed_items)
 #      feed_items.length.should == 20
 #    end

 #    it "should search for photos taken between 12 hours and now" do
 #      stub_photos = stub(:stub_photos)
 #      Timecop.freeze(Time.now)
 #      stub_photos.expects(:search).with(
 #       :bbox => '-70.014,39.986,-69.986,40.014',
 #       :min_taken_date => Time.now - 12.hours,
 #       :max_taken_date => Time.now,
 #       :accuracy => 11
 #      ).returns([])
 #      stub_flickr = stub(:flickr_stub)
 #      stub_flickr.stubs(:photos).returns(stub_photos)
 #      controller.stubs(:flickr).returns(stub_flickr)

 #      get :index, lat: "40", lng: "-70"
 #    end
 #  end
 #end
 #end
  describe "FeedItem#saved_nearby" do
    let(:lat) { 40.714269 }
    let(:lng) { -74.005972 }
    let(:two_miles) { 0.028}
    let!(:feed_item) { FeedItem.create(lat: lat, lng: lng) }

    context "an item where the coordinates are the same" do
      it "returns the item" do
        FeedItem.saved_nearby(lat, lng).should include(feed_item)
      end

      it "should return the items in reverse chronological order" do
        feed_item_older = FeedItem.create(lat: lat, lng: lng, created_at: Date.today - 1.days)
        f = FeedItem.saved_nearby(lat, lng)
        f.first.should == feed_item
        f.last.should == feed_item_older
      end
    end

    context "an item that is two miles away in any direction" do
      it "should return the item" do
        lng_nearby= -74.003972
        FeedItem.saved_nearby(lat, lng_nearby).should include(feed_item)
      end
    end

    context "an item is 2 miles north" do
      it "should return the item" do
        lat_nearby = 40.742260
        FeedItem.saved_nearby(lat_nearby, lng).should include(feed_item)
      end
    end

    context "an item is more than 2 miles away negative" do
      it "should not return the item" do
        lat_nearby = 38
        FeedItem.saved_nearby(lat_nearby, lng).should_not include(feed_item)
      end
    end
    context "an item is more than 2 miles away in the positive" do
      it "should not return the item" do
        lng_nearby = 74
        FeedItem.saved_nearby(lat, lng_nearby).should_not include(feed_item)
      end
    end

    context "an item is on the opposite side of the world" do
      it "should not return the item" do
        lat_nearby = 74
        lng_nearby = -40
        FeedItem.saved_nearby(lat_nearby, lng_nearby).should_not include(feed_item)
      end
    end
  end
end
