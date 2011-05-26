require 'spec_helper'

describe FeedItemsController do
  describe "#index" do
    describe "twitter" do
      before do
        controller.stubs(:call_foursquare).returns([])
        controller.stubs(:call_instagram).returns([])
        controller.stubs(:call_flickr).returns([])
      end
      it "should call twitter" do
        lat = 1
        lng = 2
        Twitter::Search.any_instance.expects(:geocode).with(lat, lng, "1mi")
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
        FlickRaw.stubs(:url_short).returns("short_url.com")
        one_hundred_photos = []
        100.times do
          one_hundred_photos.push(stub(title: "my cool photo"))
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
    end
  end

end
