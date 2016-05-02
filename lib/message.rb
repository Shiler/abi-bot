
class Message

  attr_accessor :from_id, :text, :message_id
  def initialize(message_id, from_id, text)
    @message_id = message_id
    @from_id    = from_id
    @text       = text + ' '
  end

end