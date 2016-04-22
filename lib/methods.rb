require 'net/http'
require 'cgi'
require 'json'


class Methods

  def Methods.get_friends(token)
    url = "https://api.vk.com/method/friends.get?&access_token=#{token}"
    json_to_hash(get_by_url(url))['response'].to_a
  end

  def Methods.send_message(id, message, token)
    url = "https://api.vk.com/method/messages.send?user_id=#{id}&message=#{message}&access_token=#{token}"
    get_by_url(url)
  end

  def Methods.get_by_url(url)
    url = URI.encode(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    response.body
  end

  def Methods.json_to_hash(json)
    JSON.parse(json)
  end

end