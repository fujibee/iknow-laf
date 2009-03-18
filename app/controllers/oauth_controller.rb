require 'oauth/consumer'

class OauthController < ApplicationController

  def index
  end

  def new_request
    consumer = OAuth::Consumer.new(
        'oauth-key',
        'oauth-secret',
        :site => "http://api.smart.fm",
        :authorize_url => "http://smart.fm/oauth/authorize")

    request_token = consumer.get_request_token(
        {}, {:api_key => "api-key"})

    logger.debug "request token: #{request_token}"
    logger.debug "authorize url: #{request_token.authorize_url}"

    redirect_to request_token.authorize_url
  end

  def callback
    raise
  end

end
