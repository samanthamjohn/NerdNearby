class WelcomeController < ApplicationController
  def index
    @mobile_request = !!(request.env["HTTP_USER_AGENT"] =~ /mobile/i)
  end

end
