require './lib/methods.rb'

class CivilCivilTask

  def initialize(data, token)
    @token = token
    @id = data[:from_id]
    @message = data[:argument]
    @forward_messages = data[:forward_messages]
  end

  def run
    message = 'Цивил, цивил '
    Methods.send_message_with_forward(@id, message, @forward_messages, @token)
  end

end