require './lib/methods.rb'
require 'date'

class UnknownCommandTask

  def initialize(id, token)
    @id = id
    @token = token
    existing = Dir['lib/command_tasks/*.rb'].map! { |elem|
      elem.to_s.gsub('.rb', '').gsub('lib/command_tasks/', '').downcase
    }
    @existing_str = ''
    existing.each do |item|
      @existing_str += "- /#{item}\n"
    end
  end

  def run
    message = "К сожалению, я не знаю такой комманды 😕\nВот список всех доступных комманд: \n" + @existing_str
    Methods.send_message(@id, message, @token)
  end

end