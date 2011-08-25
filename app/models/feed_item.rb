class FeedItem < ActiveRecord::Base
  TWO_MILES = 0.028
  before_save :add_name
  def self.saved_nearby(lat, lng)
    lat_min = lat - TWO_MILES
    lat_max = lat + TWO_MILES
    lng_min = lng - TWO_MILES
    lng_max = lng + TWO_MILES
    feed_items = FeedItem.where("lat >= ? AND lat <= ? AND lng >= ? AND lng <= ? AND created_at > ?", lat_min, lat_max, lng_min, lng_max, Date.today - 1.week)
    feed_items.where("likes > 0").sort{|a,b| b.created_at <=> a.created_at }
  end

  def self.twitter_nearby(lat, lng)
    from_users = []

    tweets = []
    twit = JSON.parse(Net::HTTP.get(URI.parse("http://search.twitter.com/search.json?geocode=#{lat},#{lng},1mi")))["results"]
    twit.try(:reject) {|tweet| tweet["text"].try(:first) == "@" || tweet["text"].include?("http")}.try(:each) do |tweet|
      next if from_users.include?(tweet["from_user"])
      from_users << tweet["from_user"]
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
    tweets.map {|item|
      feed_item = FeedItem.where({:feed_item_type => item[:feed_item_type], :type_id => item[:type_id]}).first
      feed_item || FeedItem.create!(item)
    }
  end

  def as_json(options={})
    self.attributes.reject{|key,value| value.nil? }
  end

  def self.foursquare_nearby(lat, lng)

    foursquare_venues = []
    venues = foursquare_api(ll: "#{lat}, #{lng}", limit: 50)
    venues = venues.sort {|a,b| a.json["hereNow"]["count"] <=> b.json["hereNow"]["count"]}.reverse
    venues.map do |venue|

      foursquare_venues.push({
        type_id: venue.json["id"],
        name: venue.json["name"],
        text: "#{venue.stats["checkinsCount"]} check-ins. #{venue.json["hereNow"]["count"]} here now.",
        post_time: Time.now - (rand(60)).minutes,
        url: "http://foursquare.com",
        feed_item_type: "foursquare",
        address: venue.location["address"]
      })
    end
    foursquare_venues ||= []
    foursquare_venues[0..10]
  end

  def self.foursquare_api(options={})
    foursquare = Foursquare::Base.new(ENV["FOURSQUARE_CLIENT_ID"], ENV["FOURSQUARE_CLIENT_SECRET"])
    foursquare.venues.nearby options
  end


  private

  def add_name
    self.name = "#{self.feed_item_type} post" unless self.name
  end

end
