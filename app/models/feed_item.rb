class FeedItem < ActiveRecord::Base
  TWO_MILES = 0.028
  def self.saved_nearby(lat, lng)
    lat_min = lat - TWO_MILES
    lat_max = lat + TWO_MILES
    lng_min = lng - TWO_MILES
    lng_max = lng + TWO_MILES
    feed_items = FeedItem.where("lat >= ? AND lat <= ? AND lng >= ? AND lng <= ? AND created_at > ?", lat_min, lat_max, lng_min, lng_max, Date.today - 1.week)
    feed_items.sort{|a,b| b.created_at <=> a.created_at }
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
    tweets.map {|tweet| FeedItem.new(tweet) }
  end

  def as_json(options={})
    self.attributes.reject{|key,value| value.nil? }
  end

end
