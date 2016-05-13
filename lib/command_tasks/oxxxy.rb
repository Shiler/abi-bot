require './lib/methods.rb'

class Oxxxy

  def initialize(id, token)
    @id = id
    @token = token
  end

  def run
    r = Random.new
    text_array = IO.readlines('./lib/command_tasks/oxxxy.txt').map! { |elem|
      elem.gsub('\n', '<br>')
    }
    message = "Oxxxy вещает: \n\n#{text_array[r.rand(text_array.size)]}😏"
    Methods.send_message(@id, message, @token)
  end

end