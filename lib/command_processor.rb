require_relative 'console.rb'
require_relative 'command_tasks/oxxxy.rb'
require_relative 'command_tasks/weather.rb'
require_relative 'command_tasks/rates.rb'
require_relative 'command_tasks/abi.rb'
require_relative 'command_tasks/advice.rb'
require_relative 'command_tasks/coin.rb'

class CommandProcessor

  def initialize(token)
    @token =  token
  end

  def process(message)
    if is_command?(message)
      command = message.text[/\/(\S*)\s/, 1].downcase
      argument = message.text[/\s(.*)$/, 1].chomp(' ')
      { :type => command, :argument => argument, :from_id => message.from_id }
    end
  end

  def is_command?(message)
    message.text[0] == '/' ? true : false
  end

  def make_task(command)
    case command[:type]
      when 'oxxxy'
        return Oxxxy.new(command[:from_id], @token)
      when 'weather'
        return Weather.new(command[:from_id], @token)
      when 'rates'
        return Rates.new(command[:from_id], @token)
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