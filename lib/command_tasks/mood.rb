require './lib/methods.rb'

class Mood

  def initialize(id, token)
    @id = id
    @token = token
  end

  def run
    text_array = IO.readlines('./lib/command_tasks/mood.txt').map! { |elem|
      elem.gsub('\n', '<br>')
    }
    message = text_array[rand(text_array.size)]
    Methods.send_message(@id, message, @token)
  end

end