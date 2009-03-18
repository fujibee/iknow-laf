# Hacks
# Support params in get_access_token request for smart.fm API's api_key
# http://github.com/nov/oauth_sample/blob/2499d639c0847abb22bee1f1a2dca9a01f96b303/oauth_consumer/lib/oauth_patches.rb
class OAuth::RequestToken

  def get_access_token_with_args(options = {}, *args)
    access_token_url = consumer.access_token_url? ? consumer.access_token_url : consumer.access_token_path
    response = consumer.token_request(consumer.http_method, access_token_url, self, options, *args)
    OAuth::AccessToken.new(consumer, response[:oauth_token], response[:oauth_token_secret])
  end

  alias_method :get_access_token_without_args, :get_access_token
  alias_method :get_access_token, :get_access_token_with_args

end
