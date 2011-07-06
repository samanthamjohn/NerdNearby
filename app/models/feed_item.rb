class FeedItem < ActiveRecord::Base
  TWO_MILES = 0.028
  def self.nearby(lat, lng)
    lat_min = lat - TWO_MILES
    lat_max = lat + TWO_MILES
    lng_min = lng - TWO_MILES
    lng_max = lng + TWO_MILES
    FeedItem.find_by_sql(["SELECT * FROM feed_items WHERE lat >= ? AND lat <= ? AND lng >= ? AND lng <= ?  ORDER BY 'created_at' DESC", lat_min, lat_max, lng_min, lng_max])

  end
end
