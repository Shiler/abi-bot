require './lib/methods.rb'
require './lib/constants.rb'
require 'json'
require 'colorize'
require 'net/http'
#require './lib/console.rb'


class LongPoll

  attr_accessor :server, :key, :ts, :response_hash, :long_poll_request, :from_id, :message_text


def initialize
  @url = "https://api.vk.com/method/messages.getLongPollServer?access_token=#{TOKEN}&use_ssl=0&need_pts=0"
  @methods = Methods.new
end


def get_params_for_lp(response)
hash = JSON.parse(response)
@key =  hash["response"]["key"]
@server = hash["response"]["server"]
@ts = hash["response"]["ts"]
@long_poll_request = "http://#{@server}?act=a_check&key=#{@key}&ts=#{@ts}&wait=25&mode=2"
end



def start_long_poll
get_params_for_lp(@methods.get_by_url(@url)) if @ts == nil
@response_hash =  JSON.parse(@methods.get_by_url_no_ssl(@long_poll_request))
@message_text = @response_hash["updates"].flatten[6].to_s
@from_id = @response_hash["updates"].flatten[3].to_s
puts "#{@message_text} #{@from_id}".green if message_text != ""


  if @response_hash["updates"] == []
    puts "No changes...".blue
    @methods.get_by_url_no_ssl(@long_poll_request)
  end

  if @response_hash["updates"] != []
    @ts = @response_hash["ts"]
    @long_poll_request = "http://#{@server}?act=a_check&key=#{@key}&ts=#{@ts}&wait=25&mode=2"
    @methods.get_by_url_no_ssl(@long_poll_request)
  end

end


end
