class InstagramsController < ApplicationController
  def index
    instagrams = Instagram.media_search(params[:lat], params[:lng])
    render partial: "index", locals: {instagrams: instagrams}, layout: false
  end
end
