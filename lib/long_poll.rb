require_relative 'methods.rb'
require 'colorize'
require_relative 'console.rb'

class LongPoll

  def initialize(token)
    @token  = token
    @key    = nil
    @server = nil
    @ts     = nil
    init_server
    Console.long_poll_started
    puts "key:\t#{@key}\nserver:\t#{@server}\nts:\t#{@ts}".red
  end

  def init_server
    url =  "https://api.vk.com/method/messages.getLongPollServer?use_ssl=0&need_pts=0&access_token=#{@token}"
    response = Methods.json_to_hash(Methods.get_by_url(url))['response']
    @key = response['key']
    @server = response['server']
    @ts = response['ts']
  end

  def do_iteration
    url = "http://#{@server}?act=a_check&key=#{@key}&ts=#{@ts}&wait=25&mode=2"
    response = Methods.get_by_url_no_ssl(url)
    response = Methods.json_to_hash(response)
    if response.has_key?('failed')
      Console.lp_output(response.to_s)
      init_server
      do_iteration
    else
      response
    end
  end

  def get_updates
    hash = do_iteration
    @ts = hash['ts']
    hash['updates']
  end

end
