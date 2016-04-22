require './lib/methods.rb'
require './lib/constants.rb'
require 'date'

class SendWelcomeTask

  def initialize(id, token)
    @exec_time = MorningTime
    @executed = false
    @id = id
    @token = token
  end

  def run
    message = "Ты говно... 👎💩"
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