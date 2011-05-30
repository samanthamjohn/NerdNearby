module ApplicationHelper


  def pretty_time(time)
    return "" unless time
    weekday, hour, minute = time.strftime("%A %H %M").split(" ")
    content_tag("div", "", {
      :class => "timestamp",
      "data-weekday" => weekday,
      "data-hour" => hour,
      "data-minute" => minute
    })
  end

  def tweet_maker(feed_item)
    # FIXME
    # '<a href="http://twitter.com/share" class="twitter-share-button" data-url="http://nerdnearby.com" data-text="I found \"#{instagram_text}\" nearby #{instagram[:url]}! via" data-count="none" >Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>'
  end
end
