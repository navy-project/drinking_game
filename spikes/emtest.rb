require 'em-http-request'
require 'oauth'
require 'digest/hmac'

TWITTER_CONSUMER_KEY     = ENV['CONSUMER_KEY']
TWITTER_CONSUMER_SECRET  = ENV['CONSUMER_SECRET']
TWITTER_TOKEN            = ENV['OAUTH_TOKEN']
TWITTER_TOKEN_SECRET     = ENV['OAUTH_TOKEN_SECRET']

def stream_url
  "https://stream.twitter.com/1.1/statuses/filter.json"
end

def generate_nonce
  SecureRandom.hex
end

def percent_encode(string)
  string = string.to_s
  OAuth::Helper.escape(string)
end

def get_params
  {
    :track => "linux"
  }
end

def query_string
  query = []
  get_params.each do |k,v|
    query << "#{percent_encode(k)}=#{percent_encode(v)}"
  end
  query.join("&")
end

def signing_key
  key = []
  key << percent_encode(TWITTER_CONSUMER_SECRET)
  key << percent_encode(TWITTER_TOKEN_SECRET)
  key.join "&"
end

def generate_signature
  base = []
  base << "GET"
  oauth = oauth_keys
  keys = oauth.merge(get_params)

  base << percent_encode(stream_url)
  keys.keys.sort.each do |k|
    v = keys[k]
    base << "#{percent_encode(k)}=#{percent_encode(v)}"
  end
  base_string= base.join("&")
  puts base_string
  d = Digest::HMAC.digest(base_string, signing_key, Digest::SHA1)
  oauth[:oauth_signature] = percent_encode(Base64.encode64(d).chomp("\n"))
  oauth
end

def oauth_keys
  timestamp = Time.now.to_i
  {
    :oauth_consumer_key => TWITTER_CONSUMER_KEY,
    :oauth_nonce => generate_nonce,
    :oauth_signature_method => "HMAC-SHA1",
    :oauth_timestamp => timestamp,
    :oauth_token => TWITTER_TOKEN,
    :oauth_version => "1.0"
  }
end

def signed_headers
  timestamp = Time.now.to_i
  keys = generate_signature
  auth = []
  keys.each do |k, v|
    auth << "#{k}=\"#{v}\""
  end
  auth_header = "OAuth " + auth.join(", ")
  {
    :authorization => auth_header
  }
end


def header_key(h)
  parts = h.to_s.split("_")
  parts = parts.map {|x| x[0] = x[0].upcase; x}
  parts.join("-")
end

uri = URI("#{stream_url}")
uri.query = query_string unless query_string == ""
headers = signed_headers
puts "Connecting To:", uri
p "GET", Net::HTTP.get(uri)
p "----"

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Get.new(uri)
headers.each do |h, v|
  key = header_key(h)
  puts key, v
  request[key] = v
end
puts "Sending..."
response = http.request(request)
p response
p response.body

  #p http.request(request) do |response|
  #  p response
  #  response.read_body do |chunk|
  #    puts ">>: ", chunk
  #  end
  #end
#end
