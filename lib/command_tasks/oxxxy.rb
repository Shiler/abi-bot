require './lib/methods.rb'

class Oxxxy

  def initialize(id, token)
    @id = id
    @token = token
  end

  def run
    text_array = IO.readlines('./lib/command_tasks/oxxxy.txt').map! { |elem|
      elem.gsub('\n', '<br>')
    }
    message = "Заказывали цитату Окси? Получайте 😏\n\n" + text_array[rand(text_array.size)]
    Methods.send_message(@id, message, @token)
  end

end