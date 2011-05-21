class InstagramsController < ApplicationController
  def index
    @instagram = Instagram.location_search(lat, long)
  end
end
