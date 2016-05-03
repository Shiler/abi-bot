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
    r = Random.new
    answers = %w(Орел! Решка!)
    answers[r.rand(2)]
  end

end