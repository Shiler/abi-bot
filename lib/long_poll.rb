require './lib/methods.rb'
require 'json'
require 'colorize'
require 'net/http'
#require './lib/console.rb'

#  url = 'http://imv4.vk.com\/im1797?act=a_check&key=5eda2026da3460a674c567449a20464d592282d5&ts=1769977733&wait=25&mode=2'
#  https://api.vk.com/method/messages.getLongPollServer?access_token=e2f01c3b2abbd322761bf5f7f5259fd17a4b1f7565440a0d0db05c1b67d4204dfff801e1311ec30d46ea6&use_ssl=1&need_pts=0
#'https://oauth.vk.com/blank.html#access_token=e2f01c3b2abbd322761bf5f7f5259fd17a4b1f7565440a0d0db05c1b67d4204dfff801e1311ec30d46ea6&expires_in=0&user_id=360169797'
$url = "https://api.vk.com/method/messages.getLongPollServer?access_token=e2f01c3b2abbd322761bf5f7f5259fd17a4b1f7565440a0d0db05c1b67d4204dfff801e1311ec30d46ea6&use_ssl=0&need_pts=0
"

class LongPoll


def initialize(token)
  @server = nil
  @key =  nil
  @ts = nil
  @token = token
  @response_hash = nil
  @url = "https://api.vk.com/method/messages.getLongPollServer?access_token=#{@token}&use_ssl=0&need_pts=0"
  @long_poll_request = nil
  @methods = Methods.new
  @from_id = nil
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
    message_text = @response_hash["updates"].flatten[6].to_s
    puts message_text.green if message_text != ""


  if @response_hash["updates"] == []
    puts "No changes...".blue
    @methods.get_by_url_no_ssl(@long_poll_request)
  end

  if @response_hash["updates"] != []
    #message_text = @response_hash["updates"].flatten[6].to_s
    #puts message_text.green if message_text != nil
    @ts = @response_hash["ts"]
    @long_poll_request = "http://#{@server}?act=a_check&key=#{@key}&ts=#{@ts}&wait=25&mode=2"
    @methods.get_by_url_no_ssl(@long_poll_request)
  end

end


end