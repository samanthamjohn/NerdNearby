module ApplicationHelper


  def pretty_time(time)
    time.nil? ? "" : time.strftime("%A %I:%M %p").gsub(" 0", " ")
  end
end
