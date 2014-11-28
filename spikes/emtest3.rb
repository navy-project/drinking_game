require 'em-twitter'
require 'json'

options = {
  :path   => '/1/statuses/filter.json',
  :params => { :track => 'twitter' },
  :oauth  => {
    :consumer_key     => ENV['CONSUMER_KEY'],
    :consumer_secret  => ENV['CONSUMER_SECRET'],
    :token            => ENV['OAUTH_TOKEN'],
    :token_secret     => ENV['OAUTH_TOKEN_SECRET']
  }
}

EM.run do
  begin
  client = EM::Twitter::Client.connect(options)

  client.each do |result|
      tweet = JSON.parse(result)
      puts "#{tweet["user"]["name"]} | #{tweet["text"]}"
  end
  rescue => e
    p e
  end
end
