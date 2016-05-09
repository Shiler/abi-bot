require './lib/methods.rb'
require './lib/constants.rb'
require 'date'

class WhoQuestionTask

  def initialize(token, data)
    @token = token
    @id = data[:from_id]
    @forward_messages = data[:forward_messages]
    @question = data[:argument]
  end

  def run
    random_name = get_random(get_members)
    Methods.send_message_with_forward(@id, random_name, @forward_messages, @token)
  end

  def get_members
    users = Methods.get_chat_users(@id-2000000000, @token)
    sleep 1/RequestsPerSecond
    users
  end

  def get_random(users)
    user = users[rand(users.size)]
    "#{user['first_name']} #{user['last_name']}"
  end

end