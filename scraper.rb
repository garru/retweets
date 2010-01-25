require 'rubygems'
require 'mq'
require 'yaml'
require 'twitter'

SLEEP_TIME = 10
CONFIG = YAML.load(File.open('twitter.yml').read)[ENV['RETWEET'] || 'development']
host = 'localhost'
AMQP.start(:host => host) do
  httpauth = Twitter::HTTPAuth.new(CONFIG['username'], CONFIG['password'])
  client = Twitter::Base.new(httpauth)
  last_tweet_id = nil
  amq = MQ.new
  retweetQ = amq.direct("retweets")
  EM.add_periodic_timer(SLEEP_TIME) do 
    puts "Start: last tweet id = #{last_tweet_id} #{client.rate_limit_status['remaining_hits']}"
    options = {}
    options[:since_id] = last_tweet_id unless last_tweet_id.nil?
    client.friends_timeline(options).each do |x|
      if x['text'] =~ /^RT /
        puts x.inspect
        # puts "RT found: #{x.inspect}"
        # retweetQ.publish
      end
    end
    
    client.retweeted_to_me(options.merge(:count => 500)).each do |x|
      puts x.inspect
    end
  end
end