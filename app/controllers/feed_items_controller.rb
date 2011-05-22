class FeedItemsController < ApplicationController
  def index

    tweets = Twitter::Search.new.geocode(params[:lat], params[:lng], "1mi").per_page(100).fetch.reject{|tweet| tweet.geo.nil?}.collect do |tweet|
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

    feed_items = (tweets + instagrams).sort{|a, b| a["time"] <=> b["time"] }

    render partial: "index", locals: {feed_items: feed_items}, layout: false

  end
end
