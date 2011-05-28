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
end
