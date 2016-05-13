require './lib/methods.rb'
require './lib/constants.rb'
require_relative 'basic_time_task.rb'
require 'date'

class SendWelcomeTask < BasicTimeTask

  def initialize(id, token)
    super
    @id = id
    @token = token
  end

  def run
    message = "Ты говно... 👎💩"
    Methods.send_message(@id, message, @token)
  end

end