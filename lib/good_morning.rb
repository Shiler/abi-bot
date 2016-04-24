require './lib/methods.rb'
require 'date'
require './lib/constants.rb'


class SendGoodMorningTask

  attr_accessor  :executed, :leadtime

def initialize(id,leadtime = "14:29", executed = false)
@id       = id
@executed = executed
@leadtime = leadtime
@methods  = Methods.new
end

def run
@methods.send_message(@id, MORNINGMESSAGE)
puts MORNINGMESSAGE.green
end

end
