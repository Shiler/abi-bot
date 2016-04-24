require './lib/methods.rb'
require '../lib/console'
require 'rss'
require 'colorize'


class SendExchangeRatesTask

  attr_accessor  :leadtime, :executed

  def initialize (id,leadtime = '14:29', executed = false)
  @methods  = Methods.new
  @id       = id
  @executed = executed
  @leadtime = leadtime
  end


  def run
    page = RSS::Parser.parse('http://www.nbrb.by/RSS/?p=RatesDaily')
    #"🇺🇸", "🇷🇺", "💶"
    message = "Курсы валют на сегодня:\n💶 #{page.channel.item.description.gsub(/[Д]/,"\n🇺🇸 Д").gsub(/[Р]/, "\n🇷🇺 Р")}"
    puts message.green
    @methods.send_message(@id, message)
  end

end
