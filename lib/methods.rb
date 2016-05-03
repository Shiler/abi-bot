require 'net/http'
require 'cgi'
require 'json'
require './lib/constants.rb'


class Methods

  def Methods.get_friends(token)
    url = "https://api.vk.com/method/friends.get?&access_token=#{token}"
    json_to_hash(get_by_url(url))['response'].to_a
  end

  def Methods.get_chat_users(chat_id, token)
    url = "https://api.vk.com/method/messages.getChatUsers?&chat_id=#{chat_id}&fields=screen_name&access_token=#{token}"
    json_to_hash(get_by_url(url))['response']
  end

  def Methods.send_message(id, message, token)
    random_id = rand(10000000)
    url = "https://api.vk.com/method/messages.send?peer_id=#{id}&message=#{message}&random_id=#{random_id}&v=5.50&access_token=#{token}"
    response = json_to_hash(get_by_url(url))
    if response.has_key?('error') and response['error']['error_code'] == 14
      sleep 1/RequestsPerSecond
      msg = '⚠ Too many requests! Flood protection.'
      send_message(id, msg, token)
    end
    response
  end

  def Methods.send_message_with_forward(id, message, forward_messages, token)
    random_id = rand(10000000)
    url = "https://api.vk.com/method/messages.send?peer_id=#{id}&message=#{message}&random_id=#{random_id}&forward_messages=#{forward_messages}&v=5.50&access_token=#{token}"
    get_by_url(url)
  end

  def Methods.get_by_url(url)
    url = URI.encode(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    puts "response: #{response.body}"
    response.body
  end

  def Methods.get_by_url_no_ssl(url)
    url = URI.encode(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    response.body
  end

  def Methods.json_to_hash(json)
    JSON.parse(json)
  end

end