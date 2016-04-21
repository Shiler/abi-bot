require './lib/methods.rb'
require 'rss'
require './lib/task.rb'

class SendExchangeRatesTask

  attr_accessor  :leadtime, :executed

  def initialize (id,leadtime="14:46",executed = false)
    @methods = Methods.new
    @token = Console.new.get_token
    @id = id
    @executed = executed
    #@time_helper      =
    @time_of_birthday = Time.now
    @leadtime = leadtime
  end


  def run
    page = RSS::Parser.parse('http://www.nbrb.by/RSS/?p=RatesDaily')
    #"🇺🇸", "🇷🇺", "💶"
    message = "Курсы валют на сегодня:\n💶 #{page.channel.item.description.gsub(/[Д]/,"\n🇺🇸 Д").gsub(/[Р]/, "\n🇷🇺 Р")}"
    puts message
    @methods.send_message(@id, message, @token)
  end

end
