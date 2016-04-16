require 'net/http'
require 'cgi'


class Methods

  def get_friend
    # TODO
  end

  def send_message(id, message, token)
    url = "https://api.vk.com/method/messages.send?user_id=#{id}&message=#{message}&access_token=#{token}"
    get_by_url(url)
  end

  def get_by_url(url)
    url = URI.encode(url)
    uri = URI.parse(url)
    puts uri.request_uri
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    puts response.body
    response.body
  end

end