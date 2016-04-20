require './lib/methods.rb'
require './lib/constants.rb'
require 'date'

class SendWelcomeTask

  def initialize(id, token)
    @exec_time = MorningTime
    @executed = false
    @methods = Methods.new
    @id = id
    @token = token
  end

  def run
    message = "Упс... У каждого свое утро :)\nА ты открывай глазки и радуйся новому дню!\n" +
      "И пусть он не будет таким! 👎💩"
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