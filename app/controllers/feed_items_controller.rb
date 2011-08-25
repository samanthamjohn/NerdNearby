require 'thread'
Thread.abort_on_exception = true
require 'feed_item'
class FeedItemsController < ApplicationController
  respond_to :html, :json

  def index
    begin
      tweets_thread = Thread.new{ call_twitter}
    rescue
      puts "twitter thread down"
    end
    
    begin
      foursquare_thread = Thread.new{ call_foursquare }
    rescue
      puts "foursquare thread down"
    end

    begin
      flickr_thread = Thread.new{ call_flickr }
    rescue
      puts 'flickr thread down'
    end  

    begin
      instagram_thread = Thread.new{ call_instagram }
    rescue
      puts 'instagram thread down'
    end

    favorite_feed_items = FeedItem.saved_nearby(params[:lat].to_f, params[:lng].to_f)[0...3]

    begin
      tweets = tweets_thread.value
    rescue
      puts "twitter unavailable"
      tweets = []
    end

    begin
      foursquare_venues = foursquare_thread.value 
    rescue
      puts "foursquare unavailable"
      foursquare_venues = []
    end

    begin
      flickr_pictures = flickr_thread.value
    rescue
      puts "flickr unavailable"
      flick_pictures = []
    end

    begin
      instagrams = instagram_thread.value
    rescue
      puts "instagram unavailable"
      instagrams = []
    end

    respond_to do |format|
      format.html do
        feed_items = (instagrams + flickr_pictures + tweets + foursquare_venues).sort{|a, b| b[:time] <=> a[:time] }
        max_items = @mobile_request ? 19 : 49
        @feed_items = feed_items[0..max_items].shuffle
        @feed_items.map!{|item| 
          if item.is_a?(FeedItem) 
            item  
          else
            feed_item = FeedItem.where({:feed_item_type => item[:feed_item_type], :type_id => item[:type_id]}).first
            feed_item || FeedItem.create!(item)  
          end
          }
      
        @feed_items = favorite_feed_items + @feed_items
        render partial: "index", locals: {feed_items: @feed_items}, layout: false
      end
      format.json do
        feed_items = favorite_feed_items + (instagrams + flickr_pictures + tweets + foursquare_venues).sort{|a, b| b[:time] <=> a[:time] }
        feed_items.map!{|item| item.is_a?(FeedItem) ? item : FeedItem.new(item)  }
        render json: feed_items
      end
    end
  end

  def new
    @feed_item = FeedItem.new(params[:feed_item])
  end

  def update
    @feed_item = FeedItem.find(params[:id])
    feed_item_params = params[:feed_item].merge(likes: @feed_item.likes||0 + 1)
    @feed_item.update_attributes(feed_item_params)
    respond_with @feed_item
  end

  def create
    params[:feed_item].each do |k, v|
      if params[:feed_item][k] == "null"
        params[:feed_item][k] = nil
      end
    end
    @feed_item = FeedItem.new(params[:feed_item])
    @feed_item.likes = 1
    @feed_item.save
    respond_with @feed_item
  end

  def call_twitter
    FeedItem.twitter_nearby(params[:lat], params[:lng])
  end

  def call_foursquare
    FeedItem.foursquare_nearby(params[:lat], params[:lng])
  end

  def call_instagram
    instagrams = Instagram.media_search(params[:lat], params[:lng]).collect do |instagram|
      {
        type_id: instagram.id,
        post_time: Time.at(instagram.created_time.to_i),
        image_tag: instagram.images.low_resolution.url,
        name: instagram.location.name,
        text: instagram.caption.try(:text),
        url: instagram.link,
        feed_item_type: "instagram"
      }
    end
  end


  def call_flickr
    args = {}
    radius = 0.014
    args[:bbox] = "#{params[:lng].to_f - radius},#{params[:lat].to_f - radius},#{params[:lng].to_f + radius},#{params[:lat].to_f + radius}"
    args[:min_taken_date] = Time.now - 12.hours
    args[:max_taken_date] = Time.now
    args[:accuracy] = 11
    flickr_pictures = flickr.photos.search(args).collect do |flickr_photo|
      # info = flickr.photos.getInfo({photo_id: flickr_photo.id, secret: flickr_photo.secret})
      # time: Time.parse(info.dates.try(:taken))
      {
        type_id: flickr_photo.id,
        image_tag: FlickRaw.url_m(flickr_photo),
        feed_item_type: "flickr",
        text: flickr_photo.title,
        post_time: Time.now - (rand(60)).minutes,
        url: FlickRaw.url_short(flickr_photo)
      }
    end
    flickr_pictures ||= []
    flickr_pictures[0..19]  
  end
  def global
    @feed_items = FeedItem.order("created_at desc").where("likes > 0").all  
  end
  
  def show
    @feed_item = FeedItem.find(params[:id])
  end
  
  
  
end
