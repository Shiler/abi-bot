require './lib/methods.rb'
require 'date'
require './lib/constants.rb'


class SendGoodMorningTask

  attr_accessor  :executed, :leadtime

  def initialize(id, token, leadtime = "07:30", executed = false)
    @token    = token
    @id       = id
    @executed = executed
    @leadtime = leadtime
    @methods  = Methods.new
  end

  def run
    @methods.send_message(@id, MORNINGTIME, @token)
  end

end
