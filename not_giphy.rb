require 'rubygems'
require 'sinatra'

set :root, File.dirname(__FILE__)
set :dump_errors, true
set :raise_errors, false
set :show_exceptions, false
set :port, 80

# Payload from slack:
# {
#   "token"=>"XXXXXXXXX",
#   "team_id"=>"XXXXXXX",
#   "team_domain"=>"XXXXXX",
#   "channel_id"=>"XXXXXXX",
#   "channel_name"=>"directmessage",
#   "user_id"=>"XXXXXXX",
#   "user_name"=>"carla",
#   "command"=>"/notgiphy",
#   "text"=>"doge"
# }
post '/' do
  require_relative './imgur.rb'
  query = params[:text]
  who = params[:user_name]
  channel = params[:channel_id]

  @image_search = Imgur.gifs(params[:text])
  @gif = @image_search.sample

  if @gif.nil?
    "Nothing found for that search"
  else
    result = @gif['link']
    debug("#{params['team_domain']} #{result}")
    debug(gen_payload(query, result, channel, who))
    debug(callback(query, result, channel, who))
  end
end

get '/' do
  CGI.escapeHTML 'NotGiphy - Copyright Carla Souza <contact@carlasouza.com>'
end

get '/robots.txt' do
  'User-agent: *'
end

get '/ta' do
  CGI.escapeHTML 'Copyright Carla Souza <contact@carlasouza.com>'
end

private

def callback(query, res, channel, who)
  uri = URI.parse(ENV['SLACK_URI'] || 'https://hooks.slack.com')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Post.new(ENV['SLACK_ENDPOINT'])
  request.body = gen_payload(query, res, channel, who)
  http.request(request)
end

def gen_payload(query, res, channel, who)
  payload = { text: "'#{query}' by @#{who}: <#{res}>",
              username: :notgiphy, channel: channel, icon_emoji: ':beers:' }
  "payload=#{JSON.generate(payload)}"
end

def debug(msg)
  puts "[DEBUG] #{msg}"
end

__END__
