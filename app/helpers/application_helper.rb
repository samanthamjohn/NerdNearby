module ApplicationHelper


  def pretty_time(time)
    time.nil? ? pretty_time = "" : pretty_time = time.strftime("%A %I:%M %p").gsub(" 0", " ")
    content_tag("div", pretty_time, {:class => "timestamp"})
  end
end
