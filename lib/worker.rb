require 'em-twitter'
require 'json'

require 'json'
class Worker
  def self.work!
    new.work
  end

  def work
    options = {
      :path   => '/1/statuses/filter.json',
      :params => { :track => 'Docker' },
      #:params => { :track => 'linux' },
      :oauth  => {
        :consumer_key     => ENV['CONSUMER_KEY'],
        :consumer_secret  => ENV['CONSUMER_SECRET'],
        :token            => ENV['OAUTH_TOKEN'],
        :token_secret     => ENV['OAUTH_TOKEN_SECRET']
      }
    }

    puts "Tracking Twitter: #{options[:params]}"
    faye = ENV["FAYE_HOST_ADDR"]
    puts "Publishing to FAYE: #{faye}"

    EM.run do
      begin
        client = EM::Twitter::Client.connect(options)

        client.each do |result|
          begin
            tweet = JSON.parse(result)
          t = Tweet.create!  :tweet_id => tweet["id"],
            :user => tweet["user"]["name"],
            :user_id => tweet["user"]["screen_name"],
            :user_image => tweet["user"]["profile_image_url"],
            :created_at => tweet["created_at"],
            :text => tweet["text"]
            puts "Tweet: #{t.user_id}/#{t.id}"
            message = {:channel => "/tweets/new", :data => t}
            uri = URI.parse("#{faye}/faye")
            Net::HTTP.post_form(uri, :message => message.to_json)
          rescue => e
            p e
          end
        end
      rescue => e
        p e
      end
    end
  end
end

