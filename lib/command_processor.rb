require './lib/console.rb'
require './lib/unknown_command_task.rb'
require './lib/command_tasks/oxxxy.rb'
require './lib/command_tasks/weather.rb'
require './lib/command_tasks/rates.rb'
require './lib/command_tasks/mood.rb'
require './lib/command_tasks/abi.rb'
require './lib/command_tasks/advice.rb'
require './lib/command_tasks/coin.rb'

class CommandProcessor

  def initialize(token)
    @token =  token
    @commands = Queue.new
    @existing = Dir['lib/command_tasks/*.rb'].map! { |elem|
      elem.to_s.gsub('.rb', '').gsub('lib/command_tasks/', '').downcase
    }
    Console.available_commands(@existing)
  end

  def process(message)
    if is_command?(message)
      command = message.text[/\/(\S*)\s/, 1].downcase
      argument = message.text[/\s(.*)$/, 1].chomp(' ')
      { :command => command, :argument => argument, :from_id => message.from_id }
    end
  end

  def is_command?(message)
    message.text[0] == '/' ? true : false
  end

  def make_task(command)
    case command[:command]
      when 'oxxxy'
        return Oxxxy.new(command[:from_id], @token)
      when 'weather'
        return Weather.new(command[:from_id], @token)
      when 'rates'
        return Rates.new(command[:from_id], @token)
      when 'mood'
        return Mood.new(command[:from_id], @token)
      when 'abi'
        return Abi.new(command[:from_id], command[:argument], @token)
      when 'advice'
        return Advice.new(command[:from_id], command[:argument], @token)
      when 'coin'
        return Coin.new(command[:from_id], @token)
      else
        return Abi.new(command[:from_id], 'list', @token)
    end
  end

end