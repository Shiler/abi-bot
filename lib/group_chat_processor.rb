require './lib/console.rb'
require './lib/who_question_task.rb'
require 'unicode'

class GroupChatProcessor

  def initialize(token)
    @token =  token
  end

  def process(message)
    if is_who_question?(message) && is_group(message)
      question = message.text[/(Кто|кто)\s(.*)$/, 1].chomp(' ')
      { :type => 'who_question', :argument => question, :forward_messages => message.message_id,
       :from_id => message.from_id }
    end
  end

  def is_who_question?(message)
    Unicode.downcase(message.text[0,4]) == 'кто ' ? true : false
  end

  def is_group(message)
    message.from_id/2000000000 >= 1 ? true : false
  end

  def make_task(data)
    case data[:type]
      when 'who_question'
        return WhoQuestionTask.new(@token, data)
      else
        return nil
    end
  end

end