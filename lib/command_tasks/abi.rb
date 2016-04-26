require './lib/methods.rb'

class Abi

  def initialize(id, argument, token)
    @id = id
    @argument = argument
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
    case @argument.chomp
      when 'commands', 'list', '' then
        available_commands
      else
        available_commands
    end
  end

  def available_commands
    message = "Список доступных команд: \n" + @existing_str
    Methods.send_message(@id, message, @token)
  end

end