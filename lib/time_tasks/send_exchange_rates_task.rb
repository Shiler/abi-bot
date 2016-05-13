require './lib/methods.rb'
require './lib/constants.rb'
require_relative 'basic_time_task.rb'
require 'date'

class SendExchangeRatesTask < BasicTimeTask

  def initialize(id, token, rates)
    super
    @id = id
    @token = token
    @rates = rates
  end

  def run
    message = "Курсы НБ РБ на сегодня:\n" +
      "🇷🇺 #{@rates[0]['name']} (#{@rates[0]['char_code']}): #{@rates[0]['rate']}\n" +
      "🇺🇸 #{@rates[1]['name']} (#{@rates[1]['char_code']}): #{@rates[1]['rate']}\n" +
      "💶 #{@rates[2]['name']} (#{@rates[2]['char_code']}): #{@rates[2]['rate']}"
    Methods.send_message(@id, message, @token)
  end

end