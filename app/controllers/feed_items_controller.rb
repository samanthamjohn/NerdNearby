class FeedItemsController < ApplicationController

  def index
    tweets = call_twitter
    foursquare_venues = call_foursquare
    flickr_pictures = call_flickr
    instagrams = call_instagram

    feed_items = (tweets + instagrams + foursquare_venues + flickr_pictures).sort{|a, b| b[:time] <=> a[:time] }
    @feed_items = feed_items[0..49].shuffle

    render partial: "index", locals: {feed_items: @feed_items}, layout: false

  end

  def call_twitter
    from_users = []

    tweets = []
    Twitter::Search.new.geocode(params[:lat], params[:lng], "1mi").per_page(50).fetch.try(:reject) {|tweet| tweet.text.first == "@" || tweet.text.include?("http")}.try(:each) do |tweet|
      next if from_users.include?(tweet.from_user)
      from_users << tweet.from_user
      tweets << {
        time: Time.parse(tweet.created_at),
        profile_image: tweet.profile_image_url.sub(/_normal\.jpg/, "_reasonably_small.jpg"),
        text: tweet.text,
        user: tweet.from_user,
        url: "http://twitter.com/#{tweet.from_user}/status/#{tweet.id}",
        distance: tweet.geo.try(:coordinates),
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
        venue: venue.json["name"],
        distance: distance,
        text: "#{venue.stats["checkinsCount"]} check-ins",
        time: Time.now - (rand(60)).minutes,
        url: "http://foursquare.com",
        feed_item_type: "foursquare",
        checkins: venue.stats["checkinsCount"],
        address: venue.location["address"]
      })
    end
    foursquare_venues ||= []
    foursquare_venues.sort{|a,b| b["checkins"] <=> a["checkins"]}[0..10]
  end

  def call_instagram
    instagrams = Instagram.media_search(params[:lat], params[:lng]).collect do |instagram|  
     checkin_text = instagram["caption"].blank? ? "" : instagram["caption"]["text"]
      {
        time: Time.at(instagram["created_time"].to_i),
        image_tag: instagram["images"]["low_resolution"]["url"],
        place_name: instagram["location"]["name"],
        checkin_text: checkin_text,
        url: instagram["link"],
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
        image_tag: FlickRaw.url(flickr_photo),
        feed_item_type: "flickr",
        checkin_text: flickr_photo.title,
        time: Time.now - (rand(60)).minutes,
        url: FlickRaw.url_short(flickr_photo)
      }
    end
    flickr_pictures ||= []
    flickr_pictures[0..19]

  end
end
