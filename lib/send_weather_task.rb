require './lib/methods.rb'
require './lib/constants.rb'
require 'date'

class SendWeatherTask

  def initialize(id, token, weather)
    @exec_time = MorningTime
    @executed = false
    @id = id
    @token = token
    @weather = weather
  end

  def run
    message = "Сегодня с утра погода дерьмо: #{@weather[3].gsub('Погода: ', '')} :(\n"
    message += "❄ #{@weather[0]}\n⚡ #{@weather[1]}\n💨 #{@weather[2]}\n🌫 #{@weather[4]}\n💦 #{@weather[5]}"
    Methods.send_message(@id, message, @token)
  end

  def exec_time
    @exec_time
  end

  def set_executed(bool)
    @executed = bool
  end

  def executed?
    @executed
  end

end