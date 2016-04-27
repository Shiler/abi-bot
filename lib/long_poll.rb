require './lib/methods.rb'
require 'colorize'
require './lib/console.rb'
require 'colorize'

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
    puts "response: #{Methods.get_by_url(url).to_s}"
    response = Methods.json_to_hash(Methods.get_by_url(url))['response']
    @key = response['key']
    @server = response['server']
    @ts = response['ts']
  end

  def do_iteration
    url = "http://#{@server}?act=a_check&key=#{@key}&ts=#{@ts}&wait=25&mode=2"
    Methods.get_by_url_no_ssl(url)
  end

  def get_updates
    response = Methods.json_to_hash(do_iteration)
    @ts = response['ts']
    response['updates']
  end

end