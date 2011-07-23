require 'spec_helper'

describe FeedItemsController do
  describe "#index" do
    describe "#call_twitter" do
      before do
        controller.stubs(:call_foursquare).returns([])
        controller.stubs(:call_instagram).returns([])
        controller.stubs(:call_flickr).returns([])
      end
      it "should call twitter" do
        FeedItem.should_receive(:twitter_nearby).and_return([])
        get :index, :lat => 1, :lng => 2
      end
    end

    describe "#call_flickr" do

      before do
        controller.stubs(:call_foursquare).returns([])
        controller.stubs(:call_instagram).returns([])
        controller.stubs(:call_twitter).returns([])
      end

      it "should return only 20 photos" do
        FlickRaw.stubs(:url).returns("url.com")
        FlickRaw.stubs(:url_m).returns("url.com")
        FlickRaw.stubs(:url_short).returns("short_url.com")
        one_hundred_photos = []
        50.times do
          one_hundred_photos.push(stub(id: 3, title: "my cool photo"))
        end
        stub_photos = stub(:stub_photos)
        stub_photos.expects(:search).returns(one_hundred_photos)
        stub_flickr = stub(:flickr_stub)
        stub_flickr.stubs(:photos).returns(stub_photos)
        controller.stubs(:flickr).returns(stub_flickr)

        get :index

        feed_items = assigns(:feed_items)
        feed_items.length.should == 20
      end

      it "should search for photos taken between 12 hours and now" do
        stub_photos = stub(:stub_photos)
        Timecop.freeze(Time.now)
        stub_photos.expects(:search).with(
         :bbox => '-70.014,39.986,-69.986,40.014',
         :min_taken_date => Time.now - 12.hours,
         :max_taken_date => Time.now,
         :accuracy => 11
        ).returns([])
        stub_flickr = stub(:flickr_stub)
        stub_flickr.stubs(:photos).returns(stub_photos)
        controller.stubs(:flickr).returns(stub_flickr)

        get :index, lat: "40", lng: "-70"
      end
    end
  end

  describe "global" do
    it "should show all feed items that have been liked anywhere by anyone" do
      feed_item = FeedItem.create!
      get :global
      assigns(:feed_items).should == [feed_item]
    end

  end

end
