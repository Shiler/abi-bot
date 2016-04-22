#!/usr/bin/env ruby

require './lib/console.rb'
require './lib/bot.rb'

bot = Bot.new(Console.get_token)
bot.start