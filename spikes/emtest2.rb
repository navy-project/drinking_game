require 'em-http'
require 'em-http/middleware/oauth'
require 'em-http/middleware/json_response'

require 'pp'

OAuthConfig = {
  :consumer_key     => ENV['CONSUMER_KEY'],
  :consumer_secret  => ENV['CONSUMER_SECRET'],
  :access_token     => ENV['OAUTH_TOKEN'],
  :access_token_secret => ENV['OAUTH_TOKEN_SECRET']
}

EM.run do
  # automatically parse the JSON response into a Ruby object
  EventMachine::HttpRequest.use EventMachine::Middleware::JSONResponse

  # sign the request with OAuth credentials
  conn = EventMachine::HttpRequest.new('http://api.twitter.com/1/statuses/home_timeline.json')
  conn.use EventMachine::Middleware::OAuth, OAuthConfig

  http = conn.get
  http.callback do
    pp http.response
    EM.stop
  end

  http.errback do
    puts "Failed retrieving user stream."
    pp http.response
    EM.stop
  end
end
