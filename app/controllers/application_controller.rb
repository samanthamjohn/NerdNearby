class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter(:set_mobile_request)

  private

  def set_mobile_request
    @mobile_request = !!(request.env["HTTP_USER_AGENT"] =~ /mobile/i)
  end

end
