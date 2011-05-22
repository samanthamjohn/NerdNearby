class TweetsController < ApplicationController
  def index
    tweets = Twitter::Search.new.geocode(params[:lat], params[:lng], "1mi").per_page(100).fetch.reject{|tweet| tweet.geo.nil?}
    render partial: "index", locals: {tweets: tweets}, layout: false
  end
end
