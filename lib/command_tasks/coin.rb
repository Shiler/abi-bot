require './lib/methods.rb'

class Coin

  def initialize(id, token)
    @id = id
    @token = token
  end

  def run
    message = answer
    Methods.send_message(@id, message, @token)
  end

  def answer
    answers = %w(Орел! Решка!)
    answers[rand(2)]
  end

end