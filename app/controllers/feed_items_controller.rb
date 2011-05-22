class FeedItemsController < ApplicationController
  def index

    # foursquare = Foursquare::Base.new(ENV["FOURSQUARE_CLIENT_ID"], ENV["FOURSQUARE_CLIENT_SECRET"])
    # foursquare_venues = []
    # foursquare.venues.nearby(ll: "#{params[:lat]}, #{params[:lng]}").map do |venue|
      # distance = venue.json["location"]["distance"]
      # fs_venue = foursquare.venues.find(venue.json["id"])
      # fs_venue.json["tips"]["groups"].first["items"].each do |tip|
        # time = Time.at(tip["createdAt"].to_i)
        # if time > Time.now - 12.years
          # foursquare_venues.push(
          # {
            # venue: venue.json["name"],
            # distance: distance,
            # time: Time.at(tip["createdAt"].to_i),
            # text: tip["text"],
            # feed_item_type: "foursquare"
          # }
          # )
        # end
      # end
    # end
    foursquare_venues = []

    tweets = Twitter::Search.new.geocode(params[:lat], params[:lng], "1mi").per_page(50).fetch.reject{|tweet| tweet.geo.nil?}.reject{|tweet| tweet.text.first == "@"}.collect do |tweet|
      {
        time: Time.parse(tweet.created_at),
        profile_image: tweet.profile_image_url.sub(/_normal\.jpg/, "_reasonably_small.jpg"),
        text: tweet.text,
        user: tweet.from_user,
        distance: tweet.geo.try(:coordinates),
        feed_item_type: "tweet"
      }
    end

    instagrams = Instagram.media_search(params[:lat], params[:lng]).collect do |instagram|
      {
        time: Time.at(instagram.created_time.to_i),
        image_tag: instagram.images.low_resolution.url,
        place_name: instagram.location.name,
        checkin_text: instagram.caption.try(:text),
        feed_item_type: "instagram"
      }
    end

    feed_items = (tweets + instagrams + foursquare_venues).sort{|a, b| b[:time] <=> a[:time] }

    render partial: "index", locals: {feed_items: feed_items}, layout: false

  end
end
