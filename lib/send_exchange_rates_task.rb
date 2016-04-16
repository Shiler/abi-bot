require './lib/methods.rb'

class SendExchangeRatesTask

  def initialize(id, token, rates)
    @methods = Methods.new
    @id = id
    @token = token
    @rates = rates
  end

  def run
    message = ''
    str1 = 'Курсы НБ РБ на сегодня:'
    str2 = '&#127479;&#127482;'
    #str2 = "#{@rates[0]['name']} (#{@rates[0]['char_code']}): #{@rates[0]['rate']}"
    message = str2
    puts message
    @methods.send_message(@id, message, @token)
  end

end