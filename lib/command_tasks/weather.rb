require './lib/methods.rb'
require './lib/constants.rb'
require './lib/weather.rb'
require 'date'
require 'unicode'

class Weather

  def initialize(id, token)
    @id = id
    @token = token
    @weather = Weather.get_weather
  end

  def run
    message = "В Минске на текущий момент: #{Unicode.downcase(@weather[3].gsub('Погода: ', ''))}\n"
    message += "❄ #{@weather[0]}\n⚡ #{@weather[1]}\n💨 #{@weather[2]}\n🌫 #{@weather[4]}\n💦 #{@weather[5]}"
    Methods.send_message(@id, message, @token)
  end

end