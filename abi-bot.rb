#!/usr/bin/env ruby

require './lib/console.rb'
require './lib/bot.rb'

console = Console.new
bot = Bot.new(console.get_token)
bot.start