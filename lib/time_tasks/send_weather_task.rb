require './lib/methods.rb'
require './lib/constants.rb'
require_relative 'basic_time_task.rb'
require 'date'

class SendWeatherTask < BasicTimeTask

  def initialize(id, token, weather)
    super
    @id = id
    @token = token
    @weather = weather
  end

  def run
    message = "Сегодня с утра погода дерьмо: #{@weather[3].gsub('Погода: ', '')} :(\n"
    message += "❄ #{@weather[0]}\n⚡ #{@weather[1]}\n💨 #{@weather[2]}\n🌫 #{@weather[4]}\n💦 #{@weather[5]}"
    Methods.send_message(@id, message, @token)
    sleep 10
  end

end