require_relative 'console.rb'
require_relative 'command_tasks/who_question_task.rb'
require_relative 'command_tasks/oxxxy.rb'
require_relative 'command_tasks/weather.rb'
require_relative 'command_tasks/rates.rb'
require_relative 'command_tasks/abi.rb'
require_relative 'command_tasks/advice.rb'
require_relative 'command_tasks/coin.rb'
require_relative 'command_tasks/civil_civil_task.rb'
require 'unicode'

class MessageProcessor

  def initialize(token)
    @token =  token
  end

  def process(message)
    if is_who_question?(message) && is_group_message?(message)
      question = message.text[/[КкKk][ТтTt][ОоOo]\s(.*)$/, 1].chomp(' ')
      return { :type => 'who_question', :argument => question, :forward_messages => message.message_id,
        :from_id => message.from_id }
    elsif is_civil_message?(message)
      return { :type => 'civil_message', :argument => question, :forward_messages => message.message_id,
      :from_id => message.from_id }
    elsif is_regular_message?(message)
      return { :type => 'message' }
    elsif is_unknown_command?(message)
      return { :type => 'unknown', :from_id => message.from_id}
    elsif is_command?(message)
      command = message.text[/\/(\S*)\s/, 1].downcase
      argument = message.text[/\s(.*)$/, 1].chomp(' ')
      return { :type => command, :argument => argument, :from_id => message.from_id }
    end
  end

  def is_regular_message?(message)
    message.text[0] != '/' ? true : false
  end

  def is_civil_message?(message)
    message.text == 'Цивил, цивил ' ? (return false) : nil
    Unicode.downcase(message.text[message.text.size-3, message.text.size-1]) == 'ил ' ? true : false
  end

  def is_unknown_command?(message)
    input = message.text[/\/(\S*)\s/, 1].downcase
    known = []
    Dir.open('./lib/command_tasks').each do |file|
      known << file.gsub('.rb', '') if file.split('.').pop == 'rb'
    end
    known.each do |command|
      return false if command == input
    end
    true
  end

  def make_task(message)
    data = process(message)
    case data[:type]
      when 'message'
        return nil
      when 'who_question'
        return WhoQuestionTask.new(@token, data)
      when 'oxxxy'
        return Oxxxy.new(data[:from_id], @token)
      when 'weather'
        return Weather.new(data[:from_id], @token)
      when 'rates'
        return Rates.new(data[:from_id], @token)
      when 'abi'
        return Abi.new(data[:from_id], data[:argument], @token)
      when 'advice'
        return Advice.new(data[:from_id], data[:argument], @token)
      when 'coin'
        return Coin.new(data[:from_id], @token)
      when 'civil_message'
        return CivilCivilTask.new(data, @token)
      when 'unknown'
        return Abi.new(data[:from_id], 'list', @token)
      else
        return nil
    end
  end

  def is_group_message?(message)
    message.from_id - 2000000000 > 0 ? true : false
  end

  def is_command?(message)
    message.text[0] == '/' ? true : false
  end

  def is_who_question?(message)
    /[КкKk][ТтTt][ОоOo]/.match(message.text).nil? ? false : true
  end

end