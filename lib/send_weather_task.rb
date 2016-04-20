require './lib/methods.rb'
require 'date'

class SendWeatherTask

  def initialize(id, token, rates)
    @exec_time = Time.new(2016, 04, 20, 6, 0, 0, "+03:00")
    @executed = false
    @methods = Methods.new
    @id = id
    @token = token
    @rates = rates
  end

  def run
    # TODO: WEATHER MESSAGE TEXT
    message = ''
    @methods.send_message(@id, message, @token)
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