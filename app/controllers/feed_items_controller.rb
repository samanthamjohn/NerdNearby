require 'thread'
Thread.abort_on_exception = true
class FeedItemsController < ApplicationController
  respond_to :html, :json

  def index
    tweets_thread = Thread.new{ call_twitter }
    foursquare_thread = Thread.new{ call_foursquare }
    flickr_thread = Thread.new{ call_flickr }
    instagram_thread = Thread.new{ call_instagram }
    favorite_feed_items = FeedItem.nearby(params[:lat].to_f, params[:lng].to_f)[0..5]
    tweets = tweets_thread.value
    foursquare_venues = foursquare_thread.value
    flickr_pictures = flickr_thread.value
    instagrams = instagram_thread.value

    respond_to do |format|
      format.html do
        feed_items = (instagrams + flickr_pictures + tweets + foursquare_venues).sort{|a, b| b[:time] <=> a[:time] }
        max_items = @mobile_request ? 19 : 49
        @feed_items = feed_items[0..max_items].shuffle
        @feed_items.map!{|item| FeedItem.new(item) }
        @feed_items = favorite_feed_items + @feed_items
        render partial: "index", locals: {feed_items: @feed_items}, layout: false
      end
      format.json do
        feed_items = favorite_feed_items + (instagrams + flickr_pictures + tweets + foursquare_venues).sort{|a, b| b[:time] <=> a[:time] }
        render json: feed_items.to_json
      end
    end
  end

  def new
    @feed_item = FeedItem.new(params[:feed_item])
  end

  def create
    params[:feed_item].each do |k, v|
      if params[:feed_item][k] == "null"
        params[:feed_item][k] = nil
      end
    end
    @feed_item = FeedItem.new(params[:feed_item])
    @feed_item.save
    respond_with @feed_item
  end

  def show

  end

  def call_twitter
    from_users = []

    tweets = []
    twit = JSON.parse(Net::HTTP.get(URI.parse("http://search.twitter.com/search.json?geocode=#{params[:lat]},#{params[:lng]},1mi")))["results"]
    twit.try(:reject) {|tweet| tweet["text"].try(:first) == "@" || tweet["text"].include?("http")}.try(:each) do |tweet|
      next if from_users.include?(tweet["from_user"])
      from_users << tweet["from_user"]
      if tweet["geo"]
        distance = tweet["geo"]["coordinates"]
      else
        distance = ""
      end
      tweets << {
        type_id: tweet["id"],
        post_time: Time.parse(tweet["created_at"]),
        image_tag: tweet["profile_image_url"].sub(/_normal\.jpg/, "_reasonably_small.jpg"),
        text: tweet["text"],
        user: tweet["from_user"],
        url: "http://twitter.com/#{tweet["from_user"]}/status/#{tweet["id"]}",
        feed_item_type: "tweet"
      }
    end
    tweets ||= []
  end


  def call_foursquare
    foursquare = Foursquare::Base.new(ENV["FOURSQUARE_CLIENT_ID"], ENV["FOURSQUARE_CLIENT_SECRET"])
    foursquare_venues = []
    foursquare.venues.nearby(ll: "#{params[:lat]}, #{params[:lng]}").map do |venue|
      distance = venue.json["location"]["distance"]
      foursquare_venues.push({
        type_id: venue.json["id"],
        name: venue.json["name"],
        text: "#{venue.stats["checkinsCount"]} check-ins",
        post_time: Time.now - (rand(60)).minutes,
        url: "http://foursquare.com",
        feed_item_type: "foursquare",
        address: venue.location["address"]
      })
    end
    foursquare_venues ||= []
    foursquare_venues.sort{|a,b| b["checkins"] <=> a["checkins"]}[0..10]
  end

  def call_instagram
    instagrams = Instagram.media_search(params[:lat], params[:lng]).collect do |instagram|
      {
        type_id: instagram.id,
        post_time: Time.at(instagram.created_time.to_i),
        image_tag: instagram.images.low_resolution.url,
        name: instagram.location.name,
        text: instagram.caption.try(:text),
        url: instagram.link,
        feed_item_type: "instagram"
      }
    end
  end

  def call_flickr
    args = {}
    radius = 0.014
    args[:bbox] = "#{params[:lng].to_f - radius},#{params[:lat].to_f - radius},#{params[:lng].to_f + radius},#{params[:lat].to_f + radius}"
    args[:min_taken_date] = Time.now - 12.hours
    args[:max_taken_date] = Time.now
    args[:accuracy] = 11
    flickr_pictures = flickr.photos.search(args).collect do |flickr_photo|
      # info = flickr.photos.getInfo({photo_id: flickr_photo.id, secret: flickr_photo.secret})
      # time: Time.parse(info.dates.try(:taken))
      {
        type_id: FlickRaw.id(flickr_photo),
        image_tag: FlickRaw.url_m(flickr_photo),
        feed_item_type: "flickr",
        text: flickr_photo.title,
        post_time: Time.now - (rand(60)).minutes,
        url: FlickRaw.url_short(flickr_photo)
      }
    end
    flickr_pictures ||= []
    flickr_pictures[0..19]  
  end
  def global
    @feed_items = FeedItem.all
  end
end
