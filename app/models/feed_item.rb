class FeedItem < ActiveRecord::Base
  TWO_MILES = 0.028
  def self.nearby(lat, lng)
    lat_min = lat - TWO_MILES
    lat_max = lat + TWO_MILES
    lng_min = lng - TWO_MILES
    lng_max = lng + TWO_MILES
    feed_items = FeedItem.where("lat >= ? AND lat <= ? AND lng >= ? AND lng <= ? AND created_at > ?", lat_min, lat_max, lng_min, lng_max, Date.today - 1.week)
    feed_items.sort{|a,b| b.created_at <=> a.created_at }
  end
end
